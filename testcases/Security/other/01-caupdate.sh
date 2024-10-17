#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  01-caupdate.sh
# Version	:  2.0
# Date		:  2024/05/07
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  集成CA证书
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="集成CA证书"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    ca_name="check-sm2-cert.sh"
    ca_file="${SEC_SRC_DIR_SEC}/check-sm2-cert.sh"
    cp "${ca_file}" "${TmpTestDir_LTFLIB}"
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

## TODO : 完整性保护
testcase_1() {
    rpm -qa | grep "ca-certificates-kylinsec"
    CommRetParse_LTFLIB "rpm -qa|grep ca-certificates-kylinsec"
    ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ | grep "CIVIL_SERVANT_APPLICATION_ROOT"
    CommRetParse_LTFLIB "ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ |grep CIVIL_SERVANT_APPLICATION_ROOT"
    ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ | grep "PUBLIC_APPLICATION_ROOT"
    CommRetParse_LTFLIB "ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ |grep PUBLIC_APPLICATION_ROOT"
    ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ | grep "DEVICE_APPLICATION_ROOT"
    CommRetParse_LTFLIB "ls /usr/share/pki/ca-trust-source/anchors/kylinsec/ |grep DEVICE_APPLICATION_ROOT"
}

testcase_2() {
    update-ca-trust-kylinsec
    CommRetParse_LTFLIB "update-ca-trust-kylinsec"
    cd "${TmpTestDir_LTFLIB}"
    chmod 755 "${ca_name}"
    bash "${ca_name}" | grep -q "not found"
    CommRetParse_LTFLIB "bash ${ca_name}|grep not found" "False" "yes"
    update-ca-trust-kylinsec -r
    CommRetParse_LTFLIB "update-ca-trust-kylinsec -r"
    bash "${ca_name}" | grep -q "not found"
    CommRetParse_LTFLIB "bash ${ca_name}|grep not found"
    cd -
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
