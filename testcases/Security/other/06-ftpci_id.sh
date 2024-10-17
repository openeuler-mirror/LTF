#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  06-ftpci_id.sh
# Version	:  2.0
# Date		:  2024/09/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  增加飞腾pci设备厂商id
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="增加飞腾pci设备厂商id"

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

## TODO ： 增加飞腾pci设备厂商id
#
testcase_1() {
    lspci -n | grep "8086:1528"
    CommRetParse_LTFLIB "lspci -n |grep 8086:1528"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
