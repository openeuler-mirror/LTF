#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  06-pwLoginauth.sh
# Version	:  2.0
# Date		:  2024/05/08
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#              Version 2.0, 2023/12/25
# Function	:  网络登录鉴别机制
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="系统安全要求 - 网络登录鉴别机制"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTUSER1="ltfpam06"
PASSWD1="kylin.2023"
USERIP="localhost"
AddUserNames_LTFLIB="${TESTUSER1}"
AddUserPasswds_LTFLIB="${PASSWD1}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    systemctl status firewalld | grep -q "Active: active"
    if [[ "$?" -eq 0 ]]; then
        fire_flag=1
        systemctl stop firewalld
        CommRetParse_LTFLIB "systemctl stop firewalld"

    fi
    sysauth_file="/etc/pam.d/system-auth"
    cp "${sysauth_file}" "${sysauth_file}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${sysauth_file}"
    passauth_file="/etc/pam.d/password-auth"
    cp "${passauth_file}" "${passauth_file}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${passauth_file}"
    vsftpd_file="/etc/pam.d/vsftpd"
    user_file="/etc/vsftpd/ftpusers"
    cp "${user_file}" "${user_file}.bak"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "复制配置文件失败${user_file}"
    # 创建临时文件
    test_pamlogin="${TmpTestDir_LTFLIB}/filepamlogin"
    echo "Hello LTF" >${test_pamlogin}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_pamlogin}"
    # 配置免密登录
    SshAuto_OneConfig_LTFLIB "${USERIP}" "${TESTUSER1}" "${PASSWD1}"
    TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"
    SshAuto_SetIpUser_LTFLIB "${USERIP}" "${TESTUSER1}"
    TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"
    faillock --user "${TESTUSER1}" --reset
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    if [[ "${fire_flag}" == 1 ]]; then
        systemctl restart firewalld
    fi
    rm -rf "${sysauth_file}"
    mv "${sysauth_file}.bak" "${sysauth_file}"
    rm -rf "${passauth_file}"
    mv "${passauth_file}.bak" "${passauth_file}"
    rm -rf "${user_file}"
    mv "${user_file}.bak" "${user_file}"
    Debug_LLE "rm -rf ${test_pamlogin}"
    rm -rf ${test_pamlogin}
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

## TODO ： 查看并配置相关文件
#
testcase_1() {
    cat "${sysauth_file}" | grep "auth        required      pam_faillock.so preauth audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        required      pam_faillock.so preauth audit deny=3 even_deny_root unlock_time=60" >>"${sysauth_file}"
    fi
    cat "${sysauth_file}" | grep "auth        [default=die] pam_faillock.so authfail audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        [default=die] pam_faillock.so authfail audit deny=3 even_deny_root unlock_time=60" >>"${sysauth_file}"
    fi
    cat "${sysauth_file}" | grep "auth        sufficient    pam_faillock.so authsucc audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        sufficient    pam_faillock.so authsucc audit deny=3 even_deny_root unlock_time=60" >>"${sysauth_file}"
    fi
    cat "${passauth_file}" | grep "auth        required      pam_faillock.so preauth audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        required      pam_faillock.so preauth audit deny=3 even_deny_root unlock_time=60" >>"${passauth_file}"
    fi
    cat "${passauth_file}" | grep "auth        [default=die] pam_faillock.so authfail audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        [default=die] pam_faillock.so authfail audit deny=3 even_deny_root unlock_time=60" >>"${passauth_file}"
    fi
    cat "${passauth_file}" | grep "auth        sufficient    pam_faillock.so authsucc audit deny=3 even_deny_root unlock_time=60"
    if [[ "$?" -ne 0 ]]; then
        echo "auth        sufficient    pam_faillock.so authsucc audit deny=3 even_deny_root unlock_time=60" >>"${passauth_file}"
    fi
}

## TODO  :  登录普通用户输入三次错误密码
#
testcase_2() {
    for i in {1..3}; do
        SshAuto_OneConfig_LTFLIB "${USERIP}" "${TESTUSER1}" "${PASSWD1}${i}"
        TestRetParse_LTFLIB "使用错误的密码,要求配置免密登录失败" "False" "yes"
    done
    # 被锁定后，输入正确密码应该登录失败
    ssh -t -t "${TESTUSER1}"@"${USERIP}" &>"${test_pamlogin}"
    cat "${test_pamlogin}" | grep "login"
    CommRetParse_LTFLIB "被锁定后，使用正确的密码要求配置免密登录失败" "False" "yes"
}

## TODO  :  等待60s输入正确密码应该成功登录
#
testcase_3() {
    sleep 80
    ssh -t -t "${TESTUSER1}"@"${USERIP}" &>"${test_pamlogin}"
    cat "${test_pamlogin}" | grep "login"
    CommRetParse_LTFLIB "等待60s解锁后输入正确密码可以登录" "False"
}

## TODO  :  限制普通用户无法通过FTP登录
#
testcase_4() {
    cat "${vsftpd_file}" | grep "${user_file}"
    CommRetParse_LTFLIB "cat ${vsftpd_file} | grep ${user_file}"
    cat "${user_file}" | grep "${TESTUSER1}"
    if [[ "$?" -ne 0 ]]; then
        echo "${TESTUSER1}" >>"${user_file}"
    fi
    systemctl restart vsftpd
    CommRetParse_LTFLIB "systemctl restart vsftpd"
    # 匿名连接本地FTP服务器
    which expect &>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "不存在命令: expect.请手动安装expect命令相关包."
        return $TCONF
    fi

    expect &>"${test_pamlogin}" <<-EOF
	spawn ftp localhost
	expect {
		"Name" { send "${TESTUSER1}\n";exp_continue}
        "Password" { send "${PASSWD1}\n";exp_continue}
        "ftp>" { send "quit\n"}
	}
	expect eof
	EOF
    cat "${test_pamlogin}" | grep -o "incorrect"
    CommRetParse_LTFLIB "限制普通用户${TESTUSER1}无法通过FTP登录"
}
#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
