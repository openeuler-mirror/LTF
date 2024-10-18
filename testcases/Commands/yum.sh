#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  yum.sh
# Version	:  2.0
# Date		:  2024/04/23
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令yum功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="yum 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="yum"

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

## TODO : 测试用例（yum search）
testcase_1() {
    yum search gcc &>/dev/null
    CommRetParse_LTFLIB "yum search gcc"
}

## TODO : 测试用例（yum install）
testcase_2() {
    yum install -y gcc &>/dev/null
    CommRetParse_LTFLIB "yum install -y gcc"
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    return $TPASS
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
