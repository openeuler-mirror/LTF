#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  umask.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令umask功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="umask 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="umask"

ORIGIN_UMASK=$(umask)
## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件和目录
    test_umask="${TmpTestDir_LTFLIB}/test_test_umask_dir"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${test_umask}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_umask}"
    rm -rf "${test_umask}"
    umask "${ORIGIN_UMASK}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    umask 0007
    mkdir -p "${test_umask}"
    ls -ld "${test_umask}" | grep "rwxrwx---"
    CommRetParse_LTFLIB "ls -ld ${test_umask} | grep rwxrwx---"
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
