# Websocket sandbox

## Vagrant

To create VM

```
vagrant up
```

To connect to VM

```
vagrant ssh
```

To destroy

```
vagrant destroy
```


## Vagrant VM provisioning

`provision.sh`

It installs:

- node.js
- nginx
- docker
- toy docker registry (`docker-registry.service`)
- kubernetes + nginx ingress controller (exposed with host network and deployed as daemonset `ingress-host-network.yaml`)

## Toy app

Very simple toy application that uses websockets.

```
cd app/src
npm install
node server.js
```

Exposed on 8080 port inside Vagrant VM
Forwarded to local port http://localhost:5123/

To build docker image and push it registry (required for kubernetes deployment):

```
cd app
./build.sh
```


## Proxy with nginx

Idea is to check minimal required nginx setup to be able to proxy websockets.

Nginx may fail to start automatically, because of `/vagrant` is mounted later sometimes. Just `service nginx start`.

`nginx.conf` linked to nginx config dir

Listening on 81 port.
Forwarded to http://localhost:5124/ on host


## Deploy app to kubernetes and expose with ingress

Idea is to check if websockets are forwarded by default by ingress controller or identify what minimally needs to be added.

Manifest file `kube-ws-app.yaml`. It creates:

- deployment
- service
- ingress

Deploy:

```
kubectl apply -f kube-ws-app.yaml
```

Exposed on 80 port of VM
Forwarded to http://localhost:5125/
