FROM centos:8

RUN dnf -y update && dnf -y install tang xinetd && dnf clean all
RUN mkdir /var/cache/tang
EXPOSE 80

COPY tangd.xinetd /etc/xinetd.d/tangd
COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

