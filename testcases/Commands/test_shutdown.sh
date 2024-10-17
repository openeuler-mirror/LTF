#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  test_shutdown.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令shutdown验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="常用命令shutdown验证"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="shutdown"

# 引入头文件
HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    shutdown -c
    return $TPASS
}

## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

## TODO : 测试文件和文件夹默认权限
testcase_1() {
    local conf_time="02:00"
    shutdown -P "${conf_time}" 2>&1 | grep "${conf_time}"
    CommRetParse_LTFLIB "shutdown -P ${conf_time} 2>&1 | grep ${conf_time}"

}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
