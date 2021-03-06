#!/bin/bash



main () {
	apt update
	mkdir -p /tmp/distr
	cd /tmp/distr
	install
}

install() {
	install_node
	install_nginx
	install_docker
	setup_registry_service
	install_kubernetes
	setup_ingress
}

install_node() {
	local NODE_VERSION="v12.16.1"
	fname="node-${NODE_VERSION}-linux-x64.tar.xz"
	test -e "${fname}" \
	|| wget -q "https://nodejs.org/dist/${NODE_VERSION}/${fname}"
	mkdir -p /opt/nodejs
	tar -xJf "${fname}" -C /opt/nodejs
	profile_str="export PATH=/opt/nodejs/node-${NODE_VERSION}-linux-x64/bin:\$PATH"
	grep "$profile_str" "$HOME/.bashrc" >/dev/null \
	|| echo "$profile_str" >> "$HOME/.bashrc"
	eval "$profile_str"
}

install_nginx() {
	apt install -y nginx
	unlink /etc/nginx/sites-enabled/default
	ln -s /vagrant/nginx.conf /etc/nginx/sites-available/websocket-standbox
	ln -s /etc/nginx/sites-available/websocket-standbox /etc/nginx/sites-enabled/websocket-standbox
	service nginx restart
}

install_docker() {
	curl -fsSL https://get.docker.com -o get-docker.sh
	sh get-docker.sh
}

setup_registry_service() {
	ln -s "/vagrant/docker-registry.service" /etc/systemd/system/
	systemctl enable docker-registry.service
	systemctl start docker-registry.service
}

install_kubernetes() {
	cat > /etc/sysctl.d/k8s.conf <<-EOF
		net.bridge.bridge-nf-call-ip6tables = 1
		net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system

	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	cat >/etc/apt/sources.list.d/kubernetes.list <<-EOF 
		deb https://apt.kubernetes.io/ kubernetes-xenial main
	EOF
	apt update
	apt install -y kubelet kubeadm kubectl
	apt-mark hold kubelet kubeadm kubectl

	kubeadm init
	mkdir -p $HOME/.kube
	cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
	kubectl taint node ubuntu-bionic node-role.kubernetes.io/master:NoSchedule-
	kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
}

setup_ingress() {
	kubectl apply -f "/vagrant/ingress-host-network.yaml"
}


main
