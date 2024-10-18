#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  04-userchmodmin.sh
# Version	:  2.0
# Date		:  2024/05/06
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  权限最小化
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="权限最小化"

TEST_USER1="ltfbasesec04"
PASSWD_1="olleH717.12.#$"
AddUserNames_LTFLIB="${TEST_USER1}"
AddUserPasswds_LTFLIB="${PASSWD_1}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    return $TPASS
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

## TODO : 权限最小化
testcase_1() {
    id "${TEST_USER1}" | grep "wheel"
    CommRetParse_LTFLIB "${TEST_USER1}用户权限为最小权限" "False" "yes"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
