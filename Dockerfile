# Docker Standalone Proxy
# Configure Nginx as a proxy to docker
# Expects the docker Unix socket to be volume mapped in at /var/run/docker.sock

FROM debian:wheezy

MAINTAINER Tom Noonan II <tom@tjnii.com>

# Update apt
RUN apt-get update && apt-get upgrade -y

# Install Nginx
RUN apt-get install -y nginx

# Add the docker group
# This GID is likely different from system to system, unfortunately...
RUN groupadd -g 118 docker

# Add nginx user
RUN useradd -d /tmp -s /bin/false -G docker nginx

# Install the nginx config
ADD files/etc/nginx /etc/nginx

EXPOSE 2375
CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
