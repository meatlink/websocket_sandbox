Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 8080, host: 5123
  config.vm.network "forwarded_port", guest: 80, host: 5124
  config.vm.provision "shell", inline: <<-SHELL
    NODE_VERSION="v12.16.1"
    apt update
    mkdir -p /tmp/distr
    cd /tmp/distr
    fname="node-${NODE_VERSION}-linux-x64.tar.xz"
    test -e "${fname}" \
    || wget -q "https://nodejs.org/dist/${NODE_VERSION}/${fname}"
    mkdir -p /opt/nodejs
    tar -xJf "${fname}" -C /opt/nodejs
    profile_str="export PATH=/opt/nodejs/node-${NODE_VERSION}-linux-x64/bin:\$PATH"
    grep "$profile_str" "$HOME/.bashrc" >/dev/null \
    || echo "$profile_str" >> "$HOME/.bashrc"
    eval "$profile_str"
    apt install -y nginx
    unlink /etc/nginx/sites-enabled/default
    ln -s /vagrant/nginx.conf /etc/nginx/sites-available/websocket-standbox
    ln -s /etc/nginx/sites-available/websocket-standbox /etc/nginx/sites-enabled/websocket-standbox
    service nginx restart
  SHELL
end
