#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  06-acllog.sh
# Version	:  2.0
# Date		:  2024/05/09
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  日志功能进行访问控制测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="日志功能进行访问控制测试"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTUSER1="ltfacl06"
PASSWD1="kylin.2023"
USERIP="localhost"
AddUserNames_LTFLIB="${TESTUSER1}"
AddUserPasswds_LTFLIB="${PASSWD1}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    librepolog="/var/log/dnf.librepo.log"
    cp "${librepolog}" "${librepolog}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${librepolog}"
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
    rm -rf "${librepolog}"
    mv "${librepolog}.bak" "${librepolog}"
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

## TODO ： 日志功能进行访问控制测试
#
testcase_1() {
    getfacl "${librepolog}"
    CommRetParse_LTFLIB "getfacl ${librepolog}"

    setfacl -m u:${TESTUSER1}:rwx "${librepolog}"
    CommRetParse_LTFLIB "setfacl -m u:${TESTUSER1}:rwx ${librepolog}"

    getfacl "${librepolog}" | grep "${TESTUSER1}"
    CommRetParse_LTFLIB "getfacl ${librepolog} | grep ${TESTUSER1}"

    SshAuto_CmdDef_LTFLIB "cat ${librepolog} |head -n 1" "no" "no"
    TestRetParse_LTFLIB "cat ${librepolog} |head -n 1"

    SshAuto_CmdDef_LTFLIB "echo testing>> ${librepolog}" "yes" "no"
    TestRetParse_LTFLIB "echo testing>> ${librepolog}"
    cat "${librepolog}" | tail -n 1 | grep -q "testing"
    CommRetParse_LTFLIB "cat ${librepolog} |tail -n 1 |grep -q testing"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
