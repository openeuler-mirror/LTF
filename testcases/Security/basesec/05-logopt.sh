#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  05-logopt.sh
# Version	:  2.0
# Date		:  2024/05/06
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  日志记录操作
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="日志记录操作"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TEST_USER1="ltfbasesec05"
PASSWD_1="olleH717.12.#$"
USERIP="localhost"
AddUserNames_LTFLIB="${TEST_USER1}"
AddUserPasswds_LTFLIB="${PASSWD_1}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${USERIP}" "${TEST_USER1}" "${PASSWD_1}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

    SshAuto_SetIpUser_LTFLIB "${USERIP}" "${TEST_USER1}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

    test_logopt_dir="${TmpTestDir_LTFLIB}/audit02"
    test_logopt_file="${test_logopt_dir}/testfile"
    test_logopt_rules="/etc/audit/rules.d/audit.rules"
    test_logopt_audit02="${test_logopt_dir}/ -p wxa -k file_monitor"

    cp "${test_logopt_rules}" "${test_logopt_rules}.bak"
    # 创建目录与文件
    mkdir -p "${test_logopt_dir}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建目录失败${test_logopt_dir}"

    # 创建规则
    echo "-w ${test_logopt_audit02}" >"${test_logopt_rules}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_logopt_rules}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    rm -rf "${test_logopt_dir}" "${test_logopt_file}"
    rm -rf "${test_logopt_rules}"
    mv "${test_logopt_rules}.bak" "${test_logopt_rules}"
    auditctl -l | grep "${test_logopt_audit02}" >/dev/null
    if [[ "$?" -eq 0 ]]; then
        auditctl -W ${test_logopt_audit02}
    fi
    return $TPASS
}

## TODO : 测试用例集
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

## TODO : 日志记录操作
testcase_1() {
    ausearch -i | grep "${TEST_USER1}" | grep -q "useradd"
    CommRetParse_LTFLIB "ausearch -i | grep ${TEST_USER1} | grep useradd"
    usermod -aG wheel "${TEST_USER1}"
    ausearch -i | grep "${TEST_USER1}" | grep -q "usermod"
    CommRetParse_LTFLIB "ausearch -i | grep ${TEST_USER1} | grep usermod"
    sudo login "${TEST_USER1}" &
    ausearch -i | grep "${TEST_USER1}" | grep -q "login"
    CommRetParse_LTFLIB "ausearch -i | grep ${TEST_USER1} | grep login"
}

## TODO : 用户解锁，禁用和恢复，查看日志
testcase_2() {
    passwd -l "${TEST_USER1}"
    ausearch -i | grep "passwd" | grep -q "locked"
    CommRetParse_LTFLIB "ausearch -i | grep passwd | grep locked"
    passwd -u "${TEST_USER1}"
    ausearch -i | grep "passwd" | grep -q "unlocked"
    CommRetParse_LTFLIB "ausearch -i | grep passwd | grep unlocked"
    passwd -e "${TEST_USER1}"
    ausearch -i | grep "passwd" | grep -q "expired"
    CommRetParse_LTFLIB "ausearch -i | grep passwd | grep expired"
    echo "${PASSWD_1}" | passwd --stdin "${TEST_USER1}"
}

## TODO : 重要数据目录进行审计规则添加
testcase_3() {
    cat "${test_logopt_rules}"
    auditctl -R "${test_logopt_rules}"
    auditctl -l
    CommRetParse_LTFLIB "auditctl -l"

    ausearch -i | grep "${test_logopt_dir}" | grep -E "NORMAL|CREATE"
    CommRetParse_LTFLIB "mkdir ${test_logopt_dir}成功"

    touch "${test_logopt_file}"
    echo "123" >"${test_logopt_file}"
    ausearch -i | grep "${test_logopt_file}" | grep "CREATE"
    CommRetParse_LTFLIB "touch ${test_logopt_file}成功"

    rm -rf "${test_logopt_file}"
    ausearch -i | grep "${test_logopt_file}" | grep "DELETE"
    CommRetParse_LTFLIB "rm -rf ${test_logopt_file}成功"

    local cmd="rm -rf ${test_logopt_file}"
    SshAuto_CmdDef_LTFLIB "${cmd}" "no" "yes"

    ausearch -i -ts today | grep "${cmd}"
    CommRetParse_LTFLIB "ausearch -i -ts today | grep ${cmd}"
}

## TODO : 审计日志内容查看
testcase_4() {
    ausearch --input-logs -i -ts today --just-one
    CommRetParse_LTFLIB "包括时间的日期和时间"

    ausearch --input-logs -i --just-one -ts today | grep "terminal"
    CommRetParse_LTFLIB "包括关联终端"

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
#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
