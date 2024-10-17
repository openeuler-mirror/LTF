#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   03-audit.sh
# Version:    1.0
# Date:       2022/06/24
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：
#             Version 1.0, 2022/06/24
# Function:   audit - 03 安全审计测试 - 审计保护功能测试
# Out:
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="安全审计测试 - 审计保护功能测试"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1_audit03="ltfaudit03"
passwd1_audit03="olleH717.12.#$"
userip_audit03="localhost"
AddUserNames_LTFLIB="${testuser1_audit03}"
AddUserPasswds_LTFLIB="${passwd1_audit03}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    testRules="${TmpTestDir_LTFLIB}/audit03.rules"
    auditctl_opt_audit03="${TmpTestDir_LTFLIB} -p wxa -k file_monitor"

    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${userip_audit03}" "${testuser1_audit03}" "${passwd1_audit03}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

    SshAuto_SetIpUser_LTFLIB "${userip_audit03}" "${testuser1_audit03}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    auditctl -l | grep "${auditctl_opt_audit03}" >/dev/null
    if [ $? -eq 0 ]; then
        auditctl -W ${auditctl_opt_audit03}
    fi

    return $TPASS
}

## TODO :
testcase_1() {
    local cmd="auditctl -w ${auditctl_opt_audit03}"
    SshAuto_CmdDef_LTFLIB "${cmd}" "no" "yes"
    TestRetParse_LTFLIB "普通用户修改审计规则失败"
}

## TODO :
testcase_2() {
    SshAuto_CmdDef_LTFLIB "echo ${passwd1_audit03} | sudo --stdin systemctl restart auditd" "no" "yes"
    TestRetParse_LTFLIB "普通用户sudo 无法重启 auditd 服务(sudo systemctl restart auditd)" "False"

    SshAuto_CmdDef_LTFLIB "echo ${passwd1_audit03} | sudo --stdin systemctl stop auditd" "no" "yes"
    TestRetParse_LTFLIB "普通用户sudo 无法停止 auditd 服务(sudo systemctl stop auditd)" "False"

    SshAuto_CmdDef_LTFLIB "echo ${passwd1_audit03} | sudo --stdin systemctl disable auditd" "no" "yes"
    TestRetParse_LTFLIB "普通用户sudo 无法关闭自启动 auditd 服务(sudo systemctl disable auditd)" "False"

    SshAuto_CmdDef_LTFLIB "echo ${passwd1_audit03} | sudo --stdin systemctl enable auditd" "no" "yes"
    TestRetParse_LTFLIB "普通用户sudo 无法开启自启动 auditd 服务(sudo systemctl enable auditd)" "False"
}

## TODO :
testcase_3() {
    local cmd="rm -rf /var/log/audit/audit.log"
    SshAuto_CmdDef_LTFLIB "${cmd}" "no" "yes"
    TestRetParse_LTFLIB "普通用户删除${testFile}失败"
}

## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    testcase_3

    return $TPASS
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
