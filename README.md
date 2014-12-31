Standalone Docker API Proxy
===========================

This is a Proof-Of-Concept container for proxying the Docker API with Nginx.
The intention is to use Nginx to allow fine-grained ACLs into the API.
This container runs Nginx exposing the Docker socket at /var/run/docker.sock on TCP port 2375.
The Docker daemon unix socket is expected to be volume mounted intpo the container.

Known Issues
------------

* Interactive sessions don't work

Running
-------

```bash
docker build -t test/standalone_docker_proxy .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -p 2375:2375 test/standalone_docker_proxy
export DOCKER_HOST=tcp://127.0.0.1:2375
docker ps
```

Author
------

Tom Noonan II <tom@tjnii.com>
