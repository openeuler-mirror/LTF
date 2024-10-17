#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  ps.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令ps功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="ps 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="ps"

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
    # 启动一个临时进程（例如sleep命令）用于测试
    sleep 60 &

    # 获取该临时进程的PID
    local test_pid=$($!)

    # 使用ps命令查找该临时进程
    ps aux | grep "${test_pid}"
    CommRetParse_LTFLIB "ps aux | grep ${test_pid}"
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
