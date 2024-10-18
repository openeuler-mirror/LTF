#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  install.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令install验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="install 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="install"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件
    test_install="${TmpTestDir_LTFLIB}/test-install"
    echo "Test install" >${test_install}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_install}"
    # 创建临时目录
    test_target="${TmpTestDir_LTFLIB}/install_target"
    mkdir -p "${test_target}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${test_target}"
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_install}"
    rm -rf ${test_install}
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    install -Dm0755 "${test_install}" "${test_target}"
    ls -lah "${test_target}/test-install"
    CommRetParse_LTFLIB ""
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
