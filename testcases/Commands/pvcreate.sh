#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  pvcreate.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令pvcreate功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="pvcreate 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="pvcreate losetup"

VIRTUAL_DISK="./virtual_disk_pvcreate.img"
DISK_LOOP="/dev/loop0"

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
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 创建一个10M的空文件作为虚拟磁盘
    dd if=/dev/zero of="${VIRTUAL_DISK}" bs=1M count=10

    # 将虚拟磁盘文件挂载为一个循环设备
    sudo losetup "${DISK_LOOP}" "${VIRTUAL_DISK}"

    # 使用pvcreate命令将虚拟磁盘转换为物理卷
    sudo pvcreate "${DISK_LOOP}"

    # 检查新创建的物理卷是否存在
    pvs "${DISK_LOOP}" | grep -q "${DISK_LOOP}"
    CommRetParse_LTFLIB "pvs ${DISK_LOOP} | grep -q ${DISK_LOOP}"
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
