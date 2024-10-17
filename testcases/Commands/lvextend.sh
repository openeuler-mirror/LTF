#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  lvextend.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令lvextend功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="lvextend 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="pvcreate losetup vgcreate lvcreate lvextend"

VIRTUAL_DISK="./virtual_disk_lvextend.img"
DISK_LOOP="/dev/loop0"
VOLUME_GROUP="test_vg"
LOGICAL_VOLUME="test_lv"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${VIRTUAL_DISK}"
    rm -rf "${VIRTUAL_DISK}"
    sudo losetup -d "${DISK_LOOP}"
    sudo vgremove "${VOLUME_GROUP}" --force || true
    sudo lvremove "${LOGICAL_VOLUME}" --force || true
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 创建一个20M的空文件作为虚拟磁盘
    dd if=/dev/zero of="${VIRTUAL_DISK}" bs=1M count=20

    # 将虚拟磁盘文件挂载为一个循环设备
    sudo losetup "${DISK_LOOP}" "${VIRTUAL_DISK}"

    # 使用pvcreate命令将虚拟磁盘转换为物理卷
    sudo pvcreate "${DISK_LOOP}"

    # 使用vgcreate命令创建新的卷组，包含之前创建的物理卷
    sudo vgcreate "${VOLUME_GROUP}" "${DISK_LOOP}"

    # 使用lvcreate命令在卷组上创建一个新的逻辑卷，初始大小为5M
    sudo lvcreate -L 5M -n "${LOGICAL_VOLUME}" "${VOLUME_GROUP}"

    # 使用lvextend命令扩展逻辑卷的大小到15M
    sudo lvextend -L 15M "${VOLUME_GROUP}/${LOGICAL_VOLUME}" | grep "changed"
    CommRetParse_LTFLIB "sudo lvextend -L 15M ${VOLUME_GROUP}/${LOGICAL_VOLUME} | grep changed"
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
