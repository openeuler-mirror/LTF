#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  kill.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令kill验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="kill 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="kill"

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
    bash -c "while true; do sleep 1; done &"
    kill -9 $(ps -ef | grep while | awk '{print $2}')
    # 检查临时bash进程是否已被杀死
    ps -ef | grep "while" | grep -v grep
    if [[ "$?" -eq 0 ]]; then
        OutputRet_LTFLIB ${TFAIL}
        TestRetParse_LTFLIB "kill -9 ${test_pid}失败"
    else
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "kill -9 ${test_pid}成功"
    fi
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
