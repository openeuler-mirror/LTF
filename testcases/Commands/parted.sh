#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  parted.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令parted功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="parted 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="parted losetup"

VIRTUAL_DISK="./virtual_disk_parted.img"
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

    # 使用parted命令对虚拟磁盘进行分区操作
    parted "${DISK_LOOP}" <<EOF
mklabel msdos
unit MiB
mkpart primary 1 10
quit
EOF

    # 检查新创建的分区是否存在
    parted "${DISK_LOOP}" print
    CommRetParse_LTFLIB "parted ${DISK_LOOP} print"
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
