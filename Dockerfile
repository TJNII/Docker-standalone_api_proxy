# Docker Standalone Proxy
# Configure Nginx as a proxy to docker
# Expects the docker Unix socket to be volume mapped in at /var/run/docker.sock

FROM debian:wheezy

MAINTAINER Tom Noonan II <tom@tjnii.com>

# Update apt
RUN apt-get update && apt-get upgrade -y

# Install Nginx
RUN apt-get install -y nginx

# Add nginx user
RUN useradd -d /tmp -s /bin/false nginx

# Install the nginx config
ADD files/etc/nginx /etc/nginx

# Add the start script which will set the correct group permissions and start nginx
ADD files/starter.sh /starter.sh

EXPOSE 2375
CMD ["/starter.sh"]
