#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  mount.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令mount功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="mount 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="mkfs.ext4 mkdir mount umount"

VIRTUAL_DISK="./virtual_disk_mount.img"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件和目录
    test_mount="${TmpTestDir_LTFLIB}/test_mount"
    mkdir -p "${test_mount}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${test_mount}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${VIRTUAL_DISK}"
    rm -rf "${VIRTUAL_DISK}"
    sudo umount "${test_mount}" || true
    sudo rmdir "${test_mount}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 创建一个10M的空文件作为虚拟磁盘
    dd if=/dev/zero of="${VIRTUAL_DISK}" bs=1M count=10

    # 将虚拟磁盘文件挂载为一个循环设备
    sudo losetup "${DISK_LOOP}" "${VIRTUAL_DISK}"

    # 格式化虚拟磁盘为ext4文件系统
    sudo mkfs.ext4 "${DISK_LOOP}"

    # 使用mount命令将虚拟磁盘挂载到指定目录
    sudo mount "${DISK_LOOP}" "${test_mount}"

    # 检查虚拟磁盘是否已成功挂载到指定目录
    df -h "${test_mount}" | grep -q "${DISK_LOOP}"
    CommRetParse_LTFLIB "df -h ${test_mount} | grep -q ${DISK_LOOP}"
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
