#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   02-audit.sh
# Version:    1.0
# Date:       2022/06/23
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：
#             Version 1.0, 2022/06/23
# Function:   audit - 02 安全审计测试 - 审计策略测试
# Out:
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="安全审计测试 - (审计策略测试/审计事件完备性测试)"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1_audit02="ltfaudit02"
passwd1_audit02="olleH717.12.#$"
userip_audit02="localhost"
AddUserNames_LTFLIB="${testuser1_audit02}"
AddUserPasswds_LTFLIB="${passwd1_audit02}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    testDir="${TmpTestDir_LTFLIB}/audit02"
    testFile="${testDir}/testfile"
    testRules="${TmpTestDir_LTFLIB}/audit02.rules"
    auditctl_opt_audit02="${testDir} -p wxa -k file_monitor"

    # 创建目录
    mkdir ${testDir}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${testDir}"

    # 创建规则
    echo "-w ${auditctl_opt_audit02}" >${testRules}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${testRules}"

    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${userip_audit02}" "${testuser1_audit02}" "${passwd1_audit02}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

    SshAuto_SetIpUser_LTFLIB "${userip_audit02}" "${testuser1_audit02}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    auditctl -l | grep "${auditctl_opt_audit02}" >/dev/null
    if [ $? -eq 0 ]; then
        auditctl -W ${auditctl_opt_audit02}
    fi

    return $TPASS
}

## TODO :
testcase_1() {
    cat ${testRules}
    auditctl -R ${testRules}
    CommRetParse_LTFLIB "auditctl -R ${testRules}"

    auditctl -l
    auditctl -l | grep "${auditctl_opt_audit02}"
    CommRetParse_LTFLIB "auditctl -l"
}

## TODO :
testcase_2() {
    touch ${testFile}
    CommRetParse_LTFLIB "${testFile}创建文件成功"

    local cmd="rm -rf ${testFile}"
    SshAuto_CmdDef_LTFLIB "${cmd}" "no" "yes"
    TestRetParse_LTFLIB "普通用户删除${testFile}失败"

    ausearch --input-logs -i -k file_monitor -c rm --just-one | grep "${cmd}"
    CommRetParse_LTFLIB "存在 ${testFile} 日志"

    ausearch --input-logs -i -k file_monitor -c rm --just-one | grep -E "权限不够|Permission denied"
    CommRetParse_LTFLIB "提示权限不足"
}

## TODO :
testcase_3() {
    ausearch --input-logs -i -ts today --just-one
    CommRetParse_LTFLIB "包括时间的日期和时间"

    ausearch --input-logs -i --just-one | grep "uid"
    CommRetParse_LTFLIB "包括触发的用户"

    ausearch --input-logs -i --just-one | grep "type"
    CommRetParse_LTFLIB "包括事件类型"

    ausearch --input-logs -i --just-one | grep "success"
    CommRetParse_LTFLIB "包括事件成功或失败"

    ausearch --input-logs -i --just-one | grep "type"
    CommRetParse_LTFLIB "其他与审计相关信息"

    ausearch --input-logs -i -tm ssh | grep "addr" | head -n 2
    CommRetParse_LTFLIB "身份鉴别包括请求来源"
}

testcase_4() {
    sshpass -p "${passwd1_audit02}1" ssh -o StrictHostKeyChecking=no ${testuser1_audit02}@${userip_audit02} "ls"
    ausearch -i -ts today | grep "AUTH" | grep "${testuser1_audit02}" | grep "failed"
    CommRetParse_LTFLIB "ausearch -i -ts today |grep AUTH | grep ${testuser1_audit02} | grep PAM:authentication | grep failed"
}
## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    testcase_3
    testcase_4
    return $TPASS
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
