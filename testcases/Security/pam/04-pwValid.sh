#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  04-pwValid.sh
# Version	:  2.0
# Date		:  2024/05/07
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#              Version 1.0, 2023/12/22
# Function	:  支持用户口令有效期配置
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="系统安全要求 - 支持用户口令有效期配置"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTUSER1="ltfpam04"
PASSWD1="olleH717.12.#$"
USERIP="localhost"

FILE_CONF="/etc/login.defs"
AUTH_FILE="/etc/pam.d/system-auth"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    cp "${FILE_CONF}" "${FILE_CONF}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${FILE_CONF}"
    cp "${AUTH_FILE}" "${AUTH_FILE}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${AUTH_FILE}"

    flag_str="PASS_MAX_DAYS"
    # 修改PASS_MAX_DAYS为1
    cmd="sed -i 's/${flag_str}.*$/${flag_str}   1/' ${FILE_CONF}"
    eval "${cmd}"
    #需要在修改配置文件后，再添加新用户才能生效
    useradd "${TESTUSER1}"
    echo "${PASSWD1}" | passwd --stdin "${TESTUSER1}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    # 修改为原来的日期和时间
    local two_days_later=$(date -d "$current_date - 2 days" +%Y-%m-%d)
    local two_days_later_time=$(date -d "$current_date - 2 days $current_time" +%H:%M:%S)
    date
    date -s "$two_days_later $two_days_later_time"
    CommRetParse_LTFLIB "date -s ${two_days_later} ${two_days_later_time}" "False"

    rm -rf "${FILE_CONF}"
    mv "${FILE_CONF}.bak" "${FILE_CONF}"
    rm -rf "${AUTH_FILE}"
    mv "${AUTH_FILE}.bak" "${AUTH_FILE}"
    return $TPASS
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    testcase_3
    testcase_4
    testcase_5
    testcase_6
    return $TPASS
}

## TODO ： 可使用密码最大有效期
#
testcase_1() {
    cat ${FILE_CONF} | grep -oE "${flag_str}.*"
    CommRetParse_LTFLIB "cat ${FILE_CONF}| grep -oE ${flag_str}.*" "False"
}

## TODO ：查看新建用户密码相关信息
#
testcase_2() {
    chage -l ${TESTUSER1}
    CommRetParse_LTFLIB "chage -l ${TESTUSER1}" "False"
}

## TODO ：修改系统日期为一天后
#
testcase_3() {
    # 获取当前日期和时间
    local current_date=$(date +%Y-%m-%d)
    local current_time=$(date +%H:%M:%S)

    # 修改为一天后的日期和时间
    local one_days_later=$(date -d "$current_date + 1 days" +%Y-%m-%d)
    local one_days_later_time=$(date -d "$current_date + 1 days $current_time" +%H:%M:%S)
    date
    date -s "$one_days_later $one_days_later_time"
    CommRetParse_LTFLIB "date -s ${one_days_later} ${one_days_later_time}" "False"

    # 修改时间为一天后密码没有过期，配置免密登录，应可登录
    SshAuto_OneConfig_LTFLIB "${USERIP}" "${TESTUSER1}" "${PASSWD1}"
    TestRetParse_LTFLIB "修改时间为一天后密码没有过期，配置免密登录应可登录" "True" "no" "no"
}

## TODO ：修改系统日期为两天后
#
testcase_4() {
    # 修改为两天后的日期和时间
    local one_days_later=$(date -d "$current_date + 1 days" +%Y-%m-%d)
    local one_days_later_time=$(date -d "$current_date + 1 days $current_time" +%H:%M:%S)
    date
    date -s "$one_days_later $one_days_later_time"
    CommRetParse_LTFLIB "date -s ${one_days_later} ${one_days_later_time}" "False"
}

## TODO : 登录系统查看是否有修改密码的提示
#
testcase_5() {
    # 登录用户提示expired
    sshpass -p "${PASSWD1}" ssh "${TESTUSER1}"@"${USERIP}" "exit"
    CommRetParse_LTFLIB "登录用户，终端会提示expired" "False" "yes"
}

## TODO : 增加对密码复杂度的要求
#
testcase_6() {
    cat "${AUTH_FILE}" | grep "password requisite pam_pwquality.so minlen=8 dcredit=-1 lcredit=-1 ocredit=-1 local_users_only enforce_for_root"
    if [[ "$?" -ne 0 ]]; then
        echo "123123" | passwd --stdin "${TESTUSER1}"
        CommRetParse_LTFLIB "echo "123123" | passwd --stdin ${TESTUSER1}"
        echo "password requisite pam_pwquality.so minlen=8 dcredit=-1 lcredit=-1 ocredit=-1 local_users_only enforce_for_root" >>"${AUTH_FILE}"
    fi
    echo "kylin.2023" | passwd --stdin "${TESTUSER1}"
    CommRetParse_LTFLIB "echo "kylin.2023" | passwd --stdin ${TESTUSER1}"
}
#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
