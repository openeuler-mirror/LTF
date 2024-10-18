#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  07-prohabitsu.sh
# Version	:  2.0
# Date		:  2024/05/08
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  禁止普通用户切换超级用户
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="禁止普通用户切换超级用户"

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
    # 创建临时文件
    test_pamsu="${TmpTestDir_LTFLIB}/filepamsu"
    echo "Hello LTF" >${test_pamsu}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_pamsu}"
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
    Debug_LLE "rm -rf ${test_pamsu}"
    rm -rf ${test_pamsu}
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

## TODO ： 禁止普通用户切换超级用户
#
testcase_1() {
    expect &>"${test_pamsu}" <<-EOF
spawn ssh ${TESTUSER1}@${USERIP} "su -"
expect {
    "密码" {send "${PASSWD1}\n"}
}
expect eof
EOF
    cat "${test_pamsu}" | grep "权限被拒绝"
    CommRetParse_LTFLIB "禁止普通用户切换超级用户"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
