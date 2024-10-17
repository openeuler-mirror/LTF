#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  top.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令top验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="top 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="top"

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
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    top -b -n 1
    CommRetParse_LTFLIB "top -b -n 1"
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
