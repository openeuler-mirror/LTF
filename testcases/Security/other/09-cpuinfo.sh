#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  09-cpuinfo.sh
# Version	:  1.0
# Date		:  2024/09/24
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  cpuinfo支持
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="cpuinfo支持"

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

## TODO ： 检查cpu信息
#
testcase_1() {
    # 查看cpu信息
    lscpu | grep -i CPU
    CommRetParse_LTFLIB "lscpu | grep -i CPU"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
