FROM debian:buster

###################################################################
# Generic apt configuration

ENV TERM=dumb

# apt config:  silence warnings and set defaults
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV LC_ALL=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LANG=C.UTF-8

# turn off recommends on container OS and proot OS
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > \
	    /etc/apt/apt.conf.d/01norecommend

# use stable Debian mirror
ARG DEBIAN_MIRROR=ftp.debian.org
ARG DEBIAN_SECURITY_MIRROR=security.debian.org
RUN sed -i /etc/apt/sources.list \
        -e "s/deb.debian.org/${DEBIAN_MIRROR}/" \
        -e "s/security.debian.org/${DEBIAN_SECURITY_MIRROR}/"

RUN echo exit 0 > /usr/sbin/policy-rc.d

# update Debian OS
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get clean

RUN apt-get install -y \
	curl \
    sudo \
    && apt-get clean

RUN echo "ALL ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN addgroup --gid 1000 machinekit && \
    adduser --uid 1000 --ingroup machinekit \
        --home /home/machinekit --shell /bin/bash \
        --disabled-password --gecos "" machinekit

USER machinekit