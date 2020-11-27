# !/bin/bash

WORKSPACE="/ws"

BUILDROOT_NAME="buildroot-2020.08.2"
LINUX_NAME="linux-5.5"
COMPILER_NAME="gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu"
QEMU_VERSION="5.1.0"
QEMU_NAME="qemu-${QEMU_VERSION}"

BUILDROOT_HOME="${WORKSPACE}/${BUILDROOT_NAME}"
LINUX_HOME="${WORKSPACE}/${LINUX_NAME}"
COMPILER_HOME="${WORKSPACE}/${COMPILER_NAME}"
QEMU_HOME="${WORKSPACE}/${QEMU_NAME}"

echo "===== Launch QEMU"
${QEMU_HOME}/aarch64-softmmu/qemu-system-aarch64 \
  -machine virt \
  -cpu cortex-a57 \
  -nographic \
  -smp 2 \
  -m 3072 \
  -drive format=raw,file=${BUILDROOT_HOME}/output/images/rootfs.ext3 \
  -kernel ${LINUX_HOME}/arch/arm64/boot/Image \
  -append "console=ttyAMA0 root=/dev/vda oops=panic panic_on_warn=1 panic=-1 ftrace_dump_on_oops=orig_cpu debug earlyprintk=serial slub_debug=UZ ip=dhcp" \
  -nic user,hostfwd=tcp::2222-:22
