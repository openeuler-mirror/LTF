#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  11-rtc_time_sync.sh
# Version	:  1.0
# Date		:  2024/09/29
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  支持从编译成模块的rtc驱动中同步时间
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="支持从编译成模块的rtc驱动中同步时间"

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

## TODO ： 检查RTC驱动和系统时间
#
testcase_1() {
    # 1. 显示rtc的ko文件
    kernel_version=$(uname -r)
    rtc_dir="/lib/modules/${kernel_version}/kernel/drivers/rtc"
    rtc_files=($(ls "${rtc_dir}"))
    CommRetParse_LTFLIB "ls ${rtc_dir}"

    # 初始化标志变量
    all_valid=true
    # 遍历文件列表
    for rtc_file in "${rtc_files[@]}"; do
        # 检查文件名是否符合要求
        if [[ ! "${rtc_file}" =~ ^rtc-.*\.ko\.xz$ ]]; then
            OutputRet_LTFLIB "${TFAIL}"
            TestRetParse_LTFLIB "文件 ${rtc_file} 不符合要求"
            all_valid=false
        fi
    done
    # 判断结果
    if ${all_valid}; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "所有文件均符合要求"
    fi

    # 2. 显示系统时间
    system_time=$(date)
    CommRetParse_LTFLIB "查看系统时间：${system_time}"

    # 3. 显示rtc时间
    rtc_time=$(hwclock --show)
    CommRetParse_LTFLIB "查看rtc时间：${rtc_time}"

    # 4. 设置系统时间和RTC时间同步
    hwclock -s
    CommRetParse_LTFLIB "系统时间和rtc时间同步：hwclock -s"

    # 5. 显示设置后的系统时间
    sleep 10
    # 获取系统时间
    updated_time=$(date +%Y-%m-%d\ %H:%M:%S)
    CommRetParse_LTFLIB "系统时间：${updated_time}"
    # 获取rtc时间（去掉毫秒部分）
    rtc_time=$(hwclock --show)
    CommRetParse_LTFLIB "rtc时间：${rtc_time}"

    # 比较时间差
    time_diff=$(($(date --date="${updated_time}" +%s) - $(date --date="${rtc_time}" +%s)))
    if [[ ${time_diff} -le 5 ]]; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "时间同步成功"
    else
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "时间同步失败，时间差为：${time_diff} 秒"
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
