#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  01-unknowuser.sh
# Version	:  2.0
# Date		:  2024/04/30
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  禁止存在未知用户
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="禁止存在未知用户"

TEST_USER1="ltfbasesec01"
PASSWD_1="olleH717.12.#$"
TEST_USER2="ltfpam02"
PASSWD_2="olleH717.12.#$"
AddUserNames_LTFLIB="${TEST_USER1} ${TEST_USER2}"
AddUserPasswds_LTFLIB="${PASSWD_1} ${PASSWD_2}"
ETC_PASSWD_FILE="/etc/passwd"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    usermod -aG wheel "${TEST_USER1}"
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

## TODO : 禁止存在未知用户
testcase_1() {
    Info_LLE "sync|shutdown|halt用户信息如下："
    cat "${ETC_PASSWD_FILE}" | grep -E "sync|shutdown|halt"
    Info_LLE "默认nologin用户如下，请核对："
    cat "${ETC_PASSWD_FILE}" | grep -E "nologin$" | awk -F: '{print $1}'
    local username=($(cat "${ETC_PASSWD_FILE}" | grep -E "bash$|sh$|csh$|zsh$" | awk -F: '{print $1}'))
    Info_LLE "允许shell登录列表如下："
    for name in "${username[@]}"; do
        local userid=$(id "${name}" | awk -F= '{print $2}' | tr -cd '[0-9]')
        local wg=$(id ${name} | grep -o "wheel")
        if [[ "${name}" == "root" ]]; then
            id "${name}"
            CommRetParse_LTFLIB "${name}用户允许shell登录"
        elif [[ "${userid}" =~ ^[1-9][0-9]{3,}$ ]]; then
            id "${name}"
            CommRetParse_LTFLIB "${name}用户允许shell登录"
        elif [[ "${wg}" == "wheel" ]]; then
            id "${name}"
            CommRetParse_LTFLIB "${name}用户允许shell登录"
        fi
    done
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
