#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  03-secprotocol.sh
# Version	:  2.0
# Date		:  2024/04/30
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  安全协议
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="安全协议"

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

## TODO : 安全协议
testcase_1() {
    rpm -qa | grep ssh2 &>/dev/null
    CommRetParse_LTFLIB "rpm -qa|grep ssh2"

    ssh -V 2>&1 | grep -qE "OpenSSH_8|OpenSSH_9"
    CommRetParse_LTFLIB "ssh -V | grep -qE OpenSSH_8|OpenSSH_9"

    rpm -qa | grep "tftp" &>/dev/null
    CommRetParse_LTFLIB "rpm -qa|grep tftp" "False" "yes"
    rpm -qa | grep "telnet" &>/dev/null
    CommRetParse_LTFLIB "rpm -qa|grep telnet" "False" "yes"
    rpm -qa | grep "net-snmp" &>/dev/null
    CommRetParse_LTFLIB "rpm -qa|grep net-snmp" "False" "yes"

    local ssl_result_1=$(openssl s_client -connect 10.0.0.10:5080 2>/dev/null | grep "TLSv1.2")
    local ssl_result_2=$(openssl s_client -connect 10.0.0.10:5080 -tls1_2 2>/dev/null | grep "TLSv1.2")
    local ssl_result_3=$(openssl s_client -connect 10.0.0.10:5080 -tls1_3 2>/dev/null | grep "TLSv1.2")
    if [[ "${ssl_result_1}" == "${ssl_result_2}" ]]; then
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "tls协议版本是1.2"
    elif [[ "${ssl_result_1}" == "${ssl_result_3}" ]]; then
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "tls协议版本是1.3"
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
