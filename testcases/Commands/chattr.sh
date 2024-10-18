#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  chattr.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令chattr功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="chattr 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="chattr lsattr"

CHATTR_OPTION="i"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件和目录
    test_chattr="${TmpTestDir_LTFLIB}/test_chattr"
    touch "${test_chattr}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${test_chattr}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_chattr}"
    rm -rf "${test_chattr}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 使用chattr命令添加指定属性到测试文件
    sudo chattr "+${CHATTR_OPTION}" "${test_chattr}"

    # 使用lsattr命令检查文件是否已添加指定属性
    lsattr "${test_chattr}" | grep "${CHATTR_OPTION}"
    CommRetParse_LTFLIB "lsattr ${test_chattr} | grep ${CHATTR_OPTION}"

    sudo chattr "-${CHATTR_OPTION}" "${test_chattr}"
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
