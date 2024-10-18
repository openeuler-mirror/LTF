#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  02-senprotect.sh
# Version	:  2.0
# Date		:  2024/04/30
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  敏感数据保护
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="敏感数据保护"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TEST_USER1="ltfbasesec02"
PASSWD_1="olleH717.12.#$"
USER_IP="localhost"
AddUserNames_LTFLIB="${TEST_USER1}"
AddUserPasswds_LTFLIB="${PASSWD_1}"
ETC_SHADOW_FILE="/etc/shadow"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${USER_IP}" "${TEST_USER1}" "${PASSWD_1}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

    SshAuto_SetIpUser_LTFLIB "${USER_IP}" "${TEST_USER1}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"
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
    testcase_2
    return $TPASS
}

## TODO : root用户访问敏感数据
testcase_1() {
    cat "${ETC_SHADOW_FILE}" | grep "${TEST_USER1}"
    CommRetParse_LTFLIB "cat ${ETC_SHADOW_FILE} | grep \"${TEST_USER1}\""

    local passwd_user1=$(cat ${ETC_SHADOW_FILE} | grep "${TEST_USER1}" | awk -F: '{print $2}')
    echo "${passwd_user1}" | grep ${PASSWD_1}
    CommRetParse_LTFLIB "${TEST_USER1} 用户口令以密文形式保存" "True" "yes"

    local shadow_chmod=$(ls -lah "${ETC_SHADOW_FILE}" | awk -F. '{print $1}')
    if [[ "${shadow_chmod}" == "----------" ]]; then
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "${ETC_SHADOW_FILE}权限是\"----------\""
    else
        OutputRet_LTFLIB ${TFAIL}
        TestRetParse_LTFLIB "${ETC_SHADOW_FILE}权限不是\"----------\""
    fi
}

## TODO : 普通用户访问敏感数据
testcase_2() {
    local audit_file="/var/log/audit/audit.log"
    SshAuto_CmdDef_LTFLIB "cat ${ETC_SHADOW_FILE}" "no" "yes"
    TestRetParse_LTFLIB "普通用户 ${TEST_USER1} 无权限查看文件 ${ETC_SHADOW_FILE}"

    SshAuto_CmdDef_LTFLIB "cat ${audit_file}" "no" "yes"
    TestRetParse_LTFLIB "普通用户 ${TEST_USER1} 无权限查看文件 ${audit_file}"

    SshAuto_CmdDef_LTFLIB "systemctl restart firewalld" "no" "yes"
    TestRetParse_LTFLIB "普通用户 ${TEST_USER1} 无权限重启防火墙"
}
#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
