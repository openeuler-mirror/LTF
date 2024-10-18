#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  mtools.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令mtools功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="mtools 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="mtools mdir mcopy"

DISK_LOOP="/dev/loop0"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    test_img="${TmpTestDir_LTFLIB}/mtools_img"

    test_mtools_dir="${TmpTestDir_LTFLIB}/test-mtools-dir"
    mkdir -p "${test_mtools_dir}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_mtools_dir}"

    test_mtools="${test_mtools_dir}/test-mtools"
    echo "Test mtools" >${test_mtools}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_mtools}"

    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_img} ${test_mtools} ${test_mtools_dir}"
    rm -rf "${test_img}" "${test_mtools} ${test_mtools_dir}"
    return ${TPASS}
}

## TODO : 测试用例（mdir）
testcase_1() {
    # 创建一个磁盘映像文件
    dd if=/dev/zero of="${test_img}" bs=1M count=10

    sudo losetup "${DISK_LOOP}" "${test_img}"

    # 使用mcopy将测试文件复制到磁盘映像
    mcopy -i "${test_img}" "${test_mtools}"
    CommRetParse_LTFLIB "mcopy -i ${test_img} ${test_mtools}"

    #特殊情况如此处理
    rm -rf "$(pwd)/test-mtools"
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
