#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  at.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令at验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="at 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="at"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件
    test_at="${TmpTestDir_LTFLIB}/test-at"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_at}"
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
    # 安排一个立即执行的at任务，输出当前时间到临时文件
    date >"${test_at}" | sudo at now
    # 检查临时文件是否存在并包含当前时间
    cat "${test_at}" | grep -E "^[0-9]"
    CommRetParse_LTFLIB "cat ${test_at} |grep -E ^[0-9]"
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
