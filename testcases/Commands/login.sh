#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  login.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令login验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="常用命令login验证"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="login"

TESTUSER1_LOGIN="ltflogin"
PASSWD1_LOGIN="olleH717.12.#$"
# 新建用户
AddUserNames_LTFLIB="${TESTUSER1_LOGIN}"
# 设置新用户密码
AddUserPasswds_LTFLIB="${PASSWD1_LOGIN}"

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

## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

## TODO : 测试文件和文件夹默认权限
testcase_1() {
    sudo login -f "${TESTUSER1_LOGIN}" &
    CommRetParse_LTFLIB "sudo login -f ${TESTUSER1_LOGIN} &"

}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
