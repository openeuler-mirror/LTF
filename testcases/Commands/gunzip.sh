#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  gunzip.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令gunzip功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="gunzip 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="gunzip"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件和目录
    test_gunzip="${TmpTestDir_LTFLIB}/test-gunzip"
    echo "Test gunzip" >${test_gunzip}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_gunzip}"

    test_gzip="${TmpTestDir_LTFLIB}/test-gunzip.gz"

    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_gunzip} ${test_gzip}"
    rm -rf ${test_gunzip} ${test_gzip}
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    gzip "${test_gunzip}"
    CommRetParse_LTFLIB "gzip ${test_gunzip}"

    gunzip "${test_gzip}"
    CommRetParse_LTFLIB "gunzip ${test_gzip}"

    cat "${test_gunzip}" | grep "Test gunzip"
    CommRetParse_LTFLIB "cat ${test_gunzip} | grep Test gunzip"
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
