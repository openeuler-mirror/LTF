#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  ln.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令ln验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="ln 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="ln"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件作为源文件
    test_source="${TmpTestDir_LTFLIB}/test-ln-source"
    echo "Test ln source data" >${test_source}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_source}"
    test_target="${TmpTestDir_LTFLIB}/test-ln-test_target"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_target}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_source} ${test_target}"
    rm -rf "${test_source}" "${test_target}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 执行ln命令，创建硬链接
    ln "${test_source}" "${test_target}"
    # 验证硬链接是否成功创建（假设链接文件存在且与源文件大小相同）
    cat "${test_target}" | grep "Test ln source data"
    CommRetParse_LTFLIB "cat ${test_target} | grep Test ln source data"
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
