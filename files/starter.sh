#!/bin/bash

function sighandler {
    echo "Caught $1: Shutting down"
    # Don't leverage /etc/init.d/sendsigs as it does funky stuff with SIGCONT
    # Just send everything SIGTERM
    while [ $(pgrep -vc pgrep) -gt 2 ]; do # The process substitution forks a subshell
	                                   # No attempt is made to break and send SIGKILL, Docker
	                                   # will zap all processes if they do not respond.
	kill -s SIGTERM -1 # This assumes this script is PID1
	echo "Waiting for processes to stop"
	sleep 1
    done
    exit
}

trap "sighandler SIGTERM" SIGTERM
trap "sighandler SIGINT" SIGINT

socket=/var/run/docker.sock

if [ ! -e $socket ]; then
    echo "ERROR: Docker socket not present"
    exit 1
fi

docker_gid=$(ls -n $socket | awk '{print $4}')
if [ -z "$docker_gid" ]; then
    echo "ERROR: Unable to determine socker GID"
    exit 1
fi

groupadd -g $docker_gid docker
# Add the nginx user to the docker group, using the GID of the socket
usermod -a -G docker nginx
if [ $? -ne 0 ]; then
    echo "ERROR: unable to set Nginx permissions"
    exit 1
fi

/usr/sbin/nginx -c /etc/nginx/nginx.conf
exit $?