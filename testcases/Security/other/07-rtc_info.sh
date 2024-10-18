#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  07-rtc_info.sh
# Version	:  1.0
# Date		:  2024/09/24
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  飞腾rtc设备驱动
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="飞腾rtc设备驱动"

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

## TODO ： 检查RTC信息
#
testcase_1() {
    rtc_output=$(cat /proc/driver/rtc)

    # 检查输出是否包含预期信息
    if [[ -n "$rtc_output" ]]; then
        echo "${rtc_output}" | grep -q "rtc"  # 检查是否包含"rtc"
        CommRetParse_LTFLIB "echo ${rtc_output} | grep -q rtc"
    else
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "没有找到RTC信息"
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
