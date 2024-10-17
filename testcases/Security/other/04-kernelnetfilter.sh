#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  04-kernelnetfilter.sh
# Version	:  2.0
# Date		:  2024/05/10
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  kernel Netfilter模块CVE-2021-22555漏洞处理
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="kernel Netfilter模块CVE-2021-22555漏洞处理"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTUSER1="ltfpam07"
PASSWD1="kylin.2023"
USERIP="localhost"
AddUserNames_LTFLIB="${TESTUSER1}"
AddUserPasswds_LTFLIB="${PASSWD1}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    exploit_name="exploit.c"
    exploit_file="${SEC_SRC_DIR_SEC}/${exploit_name}"
    cp "${exploit_file}" "${TmpTestDir_LTFLIB}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :${exploit_name}"
    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${USERIP}" "${TESTUSER1}" "${PASSWD1}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"
    SshAuto_SetIpUser_LTFLIB "${USERIP}" "${TESTUSER1}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${TmpTestDir_LTFLIB}/a.out ${TmpTestDir_LTFLIB}/${exploit_name}"
    rm -rf "${TmpTestDir_LTFLIB}/a.out ${TmpTestDir_LTFLIB}/${exploit_name}"
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

## TODO ： kernel Netfilter模块CVE-2021-22555漏洞处理
#
testcase_1() {
    gcc -o "${TmpTestDir_LTFLIB}/a.out" "${TmpTestDir_LTFLIB}/${exploit_name}"
    CommRetParse_LTFLIB "gcc -o ${TmpTestDir_LTFLIB}/a.out ${TmpTestDir_LTFLIB}/${exploit_name}"
    SshAuto_CmdDef_LTFLIB "${TmpTestDir_LTFLIB}/a.out;id|grep root" "no" "yes"
    TestRetParse_LTFLIB "禁止普通用户被授权为超级用户"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
