FROM centos:7

LABEL maintainer="oatkrittin@gmail.com"

ENV LMOD_VERSION=8.0
ENV JAVA_VERSION=1.8.0

# Install dependencies
RUN yum -y update && \
    yum -y install epel-release && \
    yum -y install \
      java-${JAVA_VERSION}-openjdk \
      which \
      wget \
      bzip2 \
      gcc \
      make \
      rsync \
      tcl \
      tcl-devel \
      libreadline-dev \
      readline-devel \
      lua \
      lua-devel \
      lua-posix \
      fish && \
      yum clean all && \
      rm -rf /var/cache/yum/*

RUN mkdir -p /usr/local/bin

# Install Lmod
RUN cd ~ && \
   wget https://jaist.dl.sourceforge.net/project/lmod/Lmod-${LMOD_VERSION}.tar.bz2 && \
   tar -xjvf Lmod-${LMOD_VERSION}.tar.bz2 && \
   cd Lmod-${LMOD_VERSION} && \
   ./configure --prefix=/opt/apps && \
   make && \
   make install && \
   ln -s /opt/apps/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh && \
   ln -s /opt/apps/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh

# Install Nextflow
RUN wget -qO- https://get.nextflow.io | bash && \
   mv nextflow /usr/local/bin