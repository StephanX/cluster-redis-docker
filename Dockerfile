########################

# cluster-redis-docker: centos 7 + openssh-server + redis cluster
# Config: Update root.ssh/authorized_keys with your public key
# Build: docker build --rm -t crud .

# WARNING: This section not yet tested on OSX!
# export DOCKER0IP=$(ifconfig docker0 | grep "inet" | head -n1 | awk '{ print $2}' | cut -d: -f2)
# docker run --detach --name dns-gen --publish ${DOCKER0IP}:53:53/udp --volume /var/run/docker.sock:/var/run/docker.sock jderusse/dns-gen
# sudo sed -i "s/127.0.1.1/${DOCKER0IP}/g" /etc/resolv.conf

# docker run --rm -d --name box1 crud

FROM centos:7
EXPOSE 22
# Packages
RUN yum update -y && yum install -y nmap-ncat vim openssh-server openssh-clients wget lsof which sudo

# ssh configuration
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN ssh-keygen -q -P "" -t rsa -f /etc/ssh/ssh_host_rsa_key

COPY root.ssh /root/.ssh
RUN chmod 0600 /root/.ssh/*

# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]