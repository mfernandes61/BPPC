FROM ubuntu

MAINTAINER Mark Fernandes <mark.fernandes@ifr.ac.uk>

ENV SIAB_VERSION=2.19 \
  SIAB_USERCSS="" \
#  SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=guest \
  SIAB_USERID=1000 \
  SIAB_GROUP=guest \
  SIAB_GROUPID=1000 \
  SIAB_PASSWORD=guest \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/$SIAB_USER \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none


USER root

# install pre-requisites
RUN apt-get install -y software-properties-common
RUN add-apt-repository  "deb http://archive.ubuntu.com/ubuntu precise universe" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse" && \
	add-apt-repository  "deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse" 
RUN  apt-get update && apt-get install -y build-essential git libssl-dev  libpam0g-dev zlib1g-dev dh-autoreconf openssh-client openssl 
RUN  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
# pull the shellinabox source & make it
 RUN git clone https://github.com/shellinabox/shellinabox.git
 WORKDIR shellinabox 
 RUN  autoreconf -i 
 RUN ./configure && make

ADD Welcome.txt /etc/motd
#ADD entrypoint.sh /usr/local/sbin/entrypoint.sh
ADD entrypoint.sh /entrypoint.sh
#RUN chmod +x /usr/local/sbin/entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
EXPOSE 4200
	
#USER ngsintro


VOLUME /etc/shellinabox /var/log/supervisor /home
# ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
#CMD ["shellinabox"]

WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
