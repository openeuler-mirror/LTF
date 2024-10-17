#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  08-i2c_id.sh
# Version	:  1.0
# Date		:  2024/09/24
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  增加飞腾i2c设备ID识别
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="增加飞腾i2c设备ID识别"

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

## TODO ： 检查i2c总线和设备ID
#
testcase_1() {
    # 查看i2c总线
    i2cdetect -l | grep "i2c"
    CommRetParse_LTFLIB "i2cdetect -l | grep i2c"

    # 查看挂载设备
    i2cdetect -y 0
    CommRetParse_LTFLIB "i2cdetect -y 0"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
