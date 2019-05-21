# agnostic-box

# lua-posix lua lua-filesystem lua-devel tcl needed by Lmod
# which needed by easybuild


RUN yum -y install epel-release && \
    yum -y install \
    lua-posix \
    lua \
    lua-filesystem \
    lua-devel \
    tcl \
    && \
    yum clean all && \
    rm -rf /var/cache/yum/*

# Install Lmod
RUN wget https://sourceforge.net/projects/lmod/files/Lmod-${LMOD_VERSION}.tar.bz2 && \
    tar -xvjf Lmod-${LMOD_VERSION}.tar.bz2 && \
    cd Lmod-${LMOD_VERSION} && \
    ./configure --prefix=${APPS_ROOT_PATH} && \
    make install && \
    ln -s ${APPS_ROOT_PATH}/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh && \
    ln -s ${APPS_ROOT_PATH}/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh && \
    rm -f ../Lmod-${LMOD_VERSION}.tar.bz2 
#ln -s ${APPS_ROOT_PATH}/lmod/lmod/init/profile.fish   /etc/fish/conf.d/z00_lmod.fish && \

# Create Modules user & Easybuild init script. Practices by dtu.dk
# https://wiki.fysik.dtu.dk/niflheim/EasyBuild_modules#installing-easybuild specify MODULES_HOME
RUN groupadd -g 984 modules && \
    mkdir -p $MODULES_DIR && \
    useradd -m -c "Modules user" -d $MODULES_DIR -u 984 -g modules -s /bin/bash modules && \
    chown -R modules:modules ${MODULES_DIR} && \
    chmod a+rx ${MODULES_DIR}
ADD bootstrap/etc/profile.d/z01_EasyBuild.sh /etc/profile.d/z01_EasyBuild.sh

ENV EASYBUILD_PREFIX=${MODULES_DIR}
ENV MODULEPATH=${MODULES_DIR}/modules/all:$MODULEPATH

# Switch to user `modules` to install EasyBuild
USER modules
WORKDIR /home/modules

# Install EasyBuild, Simulate source profile when we ssh
# RUN source /etc/profile.d/z00_lmod.sh && \
#     wget https://raw.githubusercontent.com/easybuilders/easybuild-framework/develop/easybuild/scripts/bootstrap_eb.py && \
#     python bootstrap_eb.py $EASYBUILD_PREFIX && \
#     rm -f bootstrap_eb.py

# Switch to root before run script
USER root