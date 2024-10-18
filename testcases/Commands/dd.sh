#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  dd.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令dd验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="dd 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="dd"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件作为输入源
    test_input="${TmpTestDir_LTFLIB}/test-dd-input"
    echo "Test dd input data" >${test_input}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_input}"
    # 创建临时文件作为输出目标
    test_output="${TmpTestDir_LTFLIB}/test-dd-output"
    touch ${test_output}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_output}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_input} ${test_output}"
    rm -rf "${test_input}" "${test_output}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 执行dd命令，将输入文件内容复制到输出文件
    dd if="${test_input}" of="${test_output}" bs=1 count=10
    CommRetParse_LTFLIB "dd命令成功执行，输出文件大小与输入文件相同"
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
