#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  chown.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令chown功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="chown 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="chown"

TESTUSER1_CHOWN="ltfchown"
PASSWD1_CHOWN="olleH717.12.#$"
# 新建用户
AddUserNames_LTFLIB="${TESTUSER1_CHOWN}"
# 设置新用户密码
AddUserPasswds_LTFLIB="${PASSWD1_CHOWN}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件
    test_chown="${TmpTestDir_LTFLIB}/test-chown"
    touch "${test_chown}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_chown}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -f ${test_chown}"
    rm -f "${test_chown}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 使用chown命令更改文件所有者为TEST_OWNER
    sudo chown "${TESTUSER1_CHOWN}" "${test_chown}"

    ls -ld "${test_chown}" | grep "${TESTUSER1_CHOWN}"
    CommRetParse_LTFLIB "ls -ld ${test_chown} | grep ${TESTUSER1_CHOWN}"
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
