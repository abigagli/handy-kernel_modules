FROM ubuntu:20.04

LABEL maintainer="abigagli"

ARG DEBIAN_FRONTEND=noninteractive
ARG NUM_CPUS=4

ARG LANG=C.UTF-8
ARG PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common python3-software-properties \
      apt-utils curl wget pkg-config unzip \
      sudo lsb-release pciutils cpio \
      build-essential sudo git \
      file unzip xz-utils rsync bc flex bison pkg-config \
      libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
      chrpath gawk texinfo libsdl1.2-dev \
      openssl libssl-dev libncurses-dev \
      vim openssh-client openssh-server

RUN apt-get install -y python3 python3-pip python3-wheel && \
    pip3 install pip --upgrade && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

ARG WORKSPACE="/ws"
ARG BUILDROOT_ID="2020.08.2"
ARG LINUX_ID="linux-5.5"
ARG COMPILER_ID="gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu"

# Download and extract sources
RUN cd /tmp && \
    mkdir -p ${WORKSPACE} && \
    \
    wget https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu/${COMPILER_ID}.tar.xz && \
    tar -xf ${COMPILER_ID}.tar.xz -C ${WORKSPACE} && \
    \
    wget https://cdn.kernel.org/pub/linux/kernel/v5.x/${LINUX_ID}.tar.xz && \
    tar -xf ${LINUX_ID}.tar.xz -C ${WORKSPACE} && \
    \
    wget https://github.com/buildroot/buildroot/archive/${BUILDROOT_ID}.tar.gz && \
    tar -xf ${BUILDROOT_ID}.tar.gz -C ${WORKSPACE}


ARG BUILDROOT_HOME="${WORKSPACE}/buildroot-${BUILDROOT_ID}"
ARG LINUX_HOME="${WORKSPACE}/${LINUX_ID}"
ARG COMPILER_HOME="${WORKSPACE}/${COMPILER_ID}"

ENV PATH="${COMPILER_HOME}/bin:$PATH"
WORKDIR ${WORKSPACE}

# COPY defconfig
COPY configs/aarch64-softmmu_buildroot_defconfig ${BUILDROOT_HOME}/configs/
COPY configs/aarch64-softmmu_kernel_defconfig ${LINUX_HOME}/arch/arm64/configs/
COPY configs/run_qemu.sh ${WORKSPACE}

ARG FORCE_UNSAFE_CONFIGURE=1
# Build root
RUN cd ${BUILDROOT_HOME} && \
    make aarch64-softmmu_buildroot_defconfig && \
    make -j${NUM_CPUS}

# Build kernel
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

RUN cd ${LINUX_HOME} && \
    make aarch64-softmmu_kernel_defconfig && \
    make -j${NUM_CPUS}

ARG QEMU_ID="5.1.0"
ARG QEMU_HOME="${WORKSPACE}/qemu-${QEMU_ID}"
# Build Qemu
# NOTE: QEMU archive downloaded from github.com
# does not work. https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg01676.html
RUN mkdir -p ${QEMU_HOME} && \
    cd ${QEMU_HOME} && \
    git clone https://git.qemu.org/git/qemu.git . && \
    git checkout v${QEMU_ID} && \
    ./configure --target-list=aarch64-softmmu,arm-softmmu && \
    make -j${NUM_CPUS}

RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/*

CMD ["/bin/bash"]
