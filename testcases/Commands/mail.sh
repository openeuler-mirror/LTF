#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  mail.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令mail功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="mail 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="mail"

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
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 设置测试邮件内容
    local test_message="This is a test email sent from the mail command."
    local mail_user="yaoxiyao@kylinsec.com.cn"
    local mail_log="/var/log/maillog"
    # 使用mail命令发送测试邮件
    echo -e "${test_message}" | mail -s "Test Mail" "${mail_user}" &>/dev/null
    # 模拟邮件发送
    cat "${mail_log}" | grep "${mail_user}"
    CommRetParse_LTFLIB "cat /var/log/maillog | grep ${mail_user}"
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
