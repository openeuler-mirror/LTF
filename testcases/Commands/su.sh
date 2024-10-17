#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  su.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令su功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="su 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="su id"

TEST_USER="ltfsu"
PASSWD1_USER="olleH717.12.#$"
# 新建用户
AddUserNames_LTFLIB="${TEST_USER}"
# 设置新用户密码
AddUserPasswds_LTFLIB="${PASSWD1_USER}"
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
    # 检查输出中是否包含TEST_USER的用户名和uid信息
    su_output=$(sudo su "${TEST_USER}" -c 'id')
    echo "${su_output}" | grep "${TEST_USER}"
    CommRetParse_LTFLIB "echo ${su_output} | grep ${TEST_USER}"
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
