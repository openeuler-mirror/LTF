#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  sudo.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令sudo功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="sudo 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="sudo whoami"

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
    # 使用sudo命令以root身份执行whoami命令
    sudo whoami | grep "root"
    CommRetParse_LTFLIB "sudo whoami | grep root"
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
