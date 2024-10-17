#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  13-feiteng_gpio.sh
# Version	:  1.0
# Date		:  2024/09/29
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  飞腾gpio支持
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="飞腾gpio支持"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    gpio_name="gpio_test.tgz"
    gpio_file="${SEC_SRC_DIR_SEC}/${gpio_name}"
    cp "${gpio_file}" "${TmpTestDir_LTFLIB}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :${gpio_name}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rmmod gpio_test.ko"
    rmmod gpio_test.ko
    Debug_LLE "rm -rf ${TmpTestDir_LTFLIB}/gpio_test ${TmpTestDir_LTFLIB}/${gpio_name}"
    rm -rf "${TmpTestDir_LTFLIB}/gpio_test ${TmpTestDir_LTFLIB}/${gpio_name}"
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

## TODO ： 飞腾gpio支持
#
testcase_1() {
    # 1. 挂载 gpiodebug 信息
    mount -t debugfs debugfs /sys/kernel/debug
    CommRetParse_LTFLIB "挂载gpiodebug信息：mount -t debugfs debugfs /sys/kernel/debug"

    # 2. 查看 GPIO 使用情况
    gpio_usage=$(cat /sys/kernel/debug/gpio)
    CommRetParse_LTFLIB "查看gpio的使用情况：cat /sys/kernel/debug/gpio"
    echo "${gpio_usage}"

    # 3. 编译 gpio_test.c 并添加模块
    tar -xvf "${TmpTestDir_LTFLIB}/${gpio_name}" -C "${TmpTestDir_LTFLIB}" &>/dev/null
    cd "${TmpTestDir_LTFLIB}/gpio_test"
    make &>/dev/null
    CommRetParse_LTFLIB "编译gpio_test.c"
    insmod gpio_test.ko
    CommRetParse_LTFLIB "添加gpio模块：insmod gpio_test.ko"

    # 4. 再次查看 GPIO 使用情况
    gpio_usage_after=$(cat /sys/kernel/debug/gpio)
    CommRetParse_LTFLIB "再次查看gpio的使用情况：cat /sys/kernel/debug/gpio"
    echo "${gpio_usage_after}"

    # 5. 比较前后的 GPIO 使用情况
    if [[ "${gpio_usage}" != "${gpio_usage_after}" ]]; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "添加模块后 GPIO 使用情况发生变化"
    else
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "添加模块后 GPIO 使用情况没有变化"
    fi

}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
