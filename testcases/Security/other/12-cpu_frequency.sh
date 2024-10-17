#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  12-cpu_frequency.sh
# Version	:  1.0
# Date		:  2024/10/10
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  cpu调频支持
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="cpu调频支持"

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
    Debug_LLE "cpupower -c all frequency-set -g performance >/dev/null"
    cpupower -c all frequency-set -g performance >/dev/null
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

## TODO ： cpu调频支持
#
testcase_1() {
    Info_LLE "注意：请在实体机上测试！虚拟机可能没有配置调频功能！"
    # 1. 查看当前 CPU 频率
    frequency_info=$(cpupower frequency-info | grep "current CPU frequency")
    CommRetParse_LTFLIB "查看当前 CPU 频率：cpupower frequency-info | grep current CPU frequency"
    Info_LLE "${frequency_info}"
    default_frequency=$(echo ${frequency_info} | awk '{print $4}')
    default_frequency_unit=$(echo ${frequency_info} | awk '{print $5}')

    # 2. 设置 CPU 频率为节能模式
    cpupower -c all frequency-set -g powersave >/dev/null
    CommRetParse_LTFLIB "设置 CPU 频率为节能模式：cpupower -c all frequency-set -g powersave >/dev/null"
    sleep 5

    # 3. 再次查看 CPU 频率
    frequency_info=$(cpupower frequency-info | grep "current CPU frequency")
    CommRetParse_LTFLIB "再次查看当前 CPU 频率：cpupower frequency-info | grep current CPU frequency"
    Info_LLE "${frequency_info}"
    powersave_frequency=$(echo ${frequency_info} | awk '{print $4}')
    powersave_frequency_unit=$(echo ${frequency_info} | awk '{print $5}')
    if [ "${default_frequency_unit}" = "GHz" ] && [ "${powersave_frequency_unit}" = "MHz" ]; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "设置节能模式后cpu频率变低"
    elif [ "${default_frequency_unit}" = "MHz" ] && [ "${powersave_frequency_unit}" = "GHz" ]; then
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "设置节能模式后cpu频率没有变低"
    else
        if [[ $(expr ${default_frequency} \> ${powersave_frequency}) == 1 ]]; then
            OutputRet_LTFLIB "${TPASS}"
            TestRetParse_LTFLIB "设置节能模式后cpu频率变低"
        else
            OutputRet_LTFLIB "${TFAIL}"
            TestRetParse_LTFLIB "设置节能模式后cpu频率没有变低"
        fi
    fi

    # 4. 设置 CPU 频率为性能模式
    cpupower -c all frequency-set -g performance >/dev/null
    CommRetParse_LTFLIB "设置 CPU 频率为性能模式：cpupower -c all frequency-set -g performance >/dev/null"
    sleep 5

    # 5. 再次查看 CPU 频率
    frequency_info=$(cpupower frequency-info | grep "current CPU frequency")
    CommRetParse_LTFLIB "再次查看当前 CPU 频率：cpupower frequency-info | grep current CPU frequency"
    echo "${frequency_info}"
    performance_frequency=$(echo ${frequency_info} | awk '{print $4}')
    performance_frequency_unit=$(echo ${frequency_info} | awk '{print $5}')
    if [ "${powersave_frequency_unit}" = "MHz" ] && [ "${performance_frequency_unit}" = "GHz" ]; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "设置性能模式后cpu频率变高"
    elif [ "${powersave_frequency_unit}" = "GHz" ] && [ "${performance_frequency_unit}" = "MHz" ]; then
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "设置性能模式后cpu频率没有变高"
    else
        if [[ $(expr ${powersave_frequency} \< ${performance_frequency}) == 1 ]]; then
            OutputRet_LTFLIB "${TPASS}"
            TestRetParse_LTFLIB "设置性能模式后cpu频率变高"
        else
            OutputRet_LTFLIB "${TFAIL}"
            TestRetParse_LTFLIB "设置性能模式后cpu频率没有变高"
        fi
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
