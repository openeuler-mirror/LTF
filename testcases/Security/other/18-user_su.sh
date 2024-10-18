#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  18-user_su.sh
# Version	:  2.0
# Date		:  2024/09/30
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  客户安全需求-su命令运行
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="客户安全需求-su命令运行"

DUSER="d5000"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "userdel -rf ${DUSER}"
    userdel -rf ${DUSER}
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    ls "/bin/csh"
    CommRetParse_LTFLIB "ls /bin/csh"
    useradd ${DUSER} -s "/bin/csh"
    if [[ "$?" -eq 9 ]]; then
        userdel -rf ${DUSER}
        CommRetParse_LTFLIB "userdel -rf ${DUSER}"
        useradd ${DUSER} -s "/bin/csh"
        CommRetParse_LTFLIB "useradd ${DUSER} -s /bin/csh"
    fi
    mkdir -p "/home/${DUSER}/test"
    CommRetParse_LTFLIB "mkdir -p /home/${DUSER}/test"
    su - ${DUSER} -c "ls" | grep test
    CommRetParse_LTFLIB "su - ${DUSER} -c ls | grep test"
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
