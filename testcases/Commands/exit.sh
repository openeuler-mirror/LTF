#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  exit.sh
# Version	:  2.0
# Date		:  2024/04/18
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令exit验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="常用命令exit验证"

# 引入头文件
HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTUSER1_LOGIN="ltfexit"
PASSWD1_LOGIN="olleH717.12.#$"
USERIP1_LOGIN="localhost"
# 新建用户
AddUserNames_LTFLIB="${TESTUSER1_LOGIN}"
# 设置新用户密码
AddUserPasswds_LTFLIB="${PASSWD1_LOGIN}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${USERIP1_LOGIN}" "${TESTUSER1_LOGIN}" "${PASSWD1_LOGIN}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

    SshAuto_SetIpUser_LTFLIB "${USERIP1_LOGIN}" "${TESTUSER1_LOGIN}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
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
    local cur_dir=$(pwd)
    Debug_LLE "${cur_dir}"
    SshAuto_CmdDef_LTFLIB "exit" "no" "no"
    local exit_cur_dir=$(pwd)
    Debug_LLE "${exit_cur_dir}"
    if [[ "${cur_dir}" != "${exit_cur_dir}" ]]; then
        OutputRet_LTFLIB ${TFAIL}
        TestRetParse_LTFLIB "退出${TESTUSER1_LOGIN}失败"
    else
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "退出${TESTUSER1_LOGIN}成功"
    fi

}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
