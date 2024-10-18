#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  nslookup.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令nslookup功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="nslookup 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="nslookup"

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
    # 设置测试域名
    local test_domain="http://ones.kylinsec.com.cn/"
    # 使用nslookup命令查询域名的A记录
    nslookup "${test_domain}" | grep "Address:"
    CommRetParse_LTFLIB "nslookup ${test_domain} | grep Address:"
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
