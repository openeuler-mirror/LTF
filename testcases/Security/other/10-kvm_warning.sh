#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  10-kvm_warning.sh
# Version	:  1.0
# Date		:  2024/09/24
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  kvm去掉非海思设备的警告信息
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="kvm去掉非海思设备的警告信息"

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

## TODO ： 检查KVM相关日志
#
testcase_1() {
    # 查看dmesg中KVM的日志信息
    dmesg | grep -i kvm | grep -i "warning\|error\|fail"
    CommRetParse_LTFLIB "dmesg | grep -i kvm | grep -i warning\|error\|fail" "true" "yes"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
