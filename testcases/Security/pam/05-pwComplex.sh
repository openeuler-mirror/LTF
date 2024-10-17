#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  pwComplex
# Version	:  1.0
# Date		:  2023/12/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#              Version 1.0, 2023/12/22
# Function	:  支持用户口令复杂度校验及强口令管理
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="系统安全要求 - 支持用户口令复杂度校验及强口令管理"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1="ltfpam05"
passwd1="olleH717.12.#$"
testuser2="ltfpam02-2"
passwd2="olleH717.12.#$"
userip="localhost"
AddUserNames_LTFLIB="${testuser1} ${testuser2}"
AddUserPasswds_LTFLIB="${passwd1} ${passwd2}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件
    test_pamcom="${TmpTestDir_LTFLIB}/filepamcom"
    echo "Hello LTF" >${test_pamcom}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_pamcom}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_pamcom}"
    rm -rf ${test_pamcom}
    return $TPASS
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    local milestone=$(cat /etc/.kyinfo | grep "milestone")
    local version_num=$(echo -e "${milestone}" | awk -F= '{print $2}' | sed 's/-[a-z].*//g' | sed 's/[A-Z]-[0-9].*//')
    if [[ "${version_num}" == "3.6.1" ]]; then
        testcase_4
    else
        testcase_3
    fi
    return $TPASS
}

## TODO ： 用户口令复杂度校验
#
testcase_1() {
    # LTF已创建用户，查看默认密码复杂度策略
    local file_conf="/etc/pam.d/system-auth"
    cat ${file_conf}
    CommRetParse_LTFLIB "cat ${file_conf}" "False"
}

## TODO ：强口令管理
#
testcase_2() {
    echo "kylin@13" | passwd --stdin "${testuser1}"
    CommRetParse_LTFLIB "设置8位密码" "False"
    passwd -u "${testuser2}"

    echo "kylin@123456" | passwd --stdin "${testuser1}"
    CommRetParse_LTFLIB "设置8位以上、20位以下密码" "False"
    passwd -u "${testuser2}"

    echo "kylin@13.36425272dsg" | passwd --stdin "${testuser1}"
    CommRetParse_LTFLIB "设置20位的密码" "False"
    passwd -u "${testuser2}"
}

## TODO ：验证密码不符合要求时不能设置成功
#
testcase_3() {
    echo "os@13" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置小于8位密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "12345678" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位全是数字的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "asfgjkbn" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位全是字母的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "&^%$#@!*" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位全是特殊符号的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "kylin@*&" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位但只有字母和特殊符号的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "kylin123" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位但是只有数字和字母的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "&^%$&123" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置8位但是只有数字和特殊符号的密码" "False" "yes"
    passwd -u "${testuser2}"

    echo "root@123" | passwd --stdin "${testuser2}"
    CommRetParse_LTFLIB "设置包含了用户名的密码" "False" "yes"
    passwd -u "${testuser2}"
}

## TODO ：验证密码不符合要求时能设置成功，但有警告
#
testcase_4() {
    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "123123\n";exp_continue}
       "重新输入新的密码" {send "123123\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -o "密码少于 8 个字符"
    CommRetParse_LTFLIB "设置小于8位密码有警告"
    passwd -u "${testuser2}"

    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "12345678\n";exp_continue}
       "重新输入新的密码" {send "12345678\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -o "密码包含少于 3 的字符类型"
    CommRetParse_LTFLIB "设置8位全是数字的密码有警告"
    passwd -u "${testuser2}"

    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "abcdefghi\n";exp_continue}
       "重新输入新的密码" {send "abcdefghi\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -o "密码包含少于 3 的字符类型"
    CommRetParse_LTFLIB "设置8位全是字母的密码有警告"
    passwd -u "${testuser2}"

    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "&^%$#@!*(\n";exp_continue}
       "重新输入新的密码" {send "&^%$#@!*(\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -o "密码包含少于 3 的字符类型"
    CommRetParse_LTFLIB "设置8位全是特殊符号的密码有警告"
    passwd -u "${testuser2}"

    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "root@123\n";exp_continue}
       "重新输入新的密码" {send "root@123\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -o "密码未通过字典检查"
    CommRetParse_LTFLIB "设置包含了用户名的密码有警告"
    passwd -u "${testuser2}"

    expect &>"${test_pamcom}" <<-EOF
spawn passwd "${testuser2}"             
expect {
       "新的密码" {send "kylin.123\n";exp_continue}
       "重新输入新的密码" {send "kylin.123\n"}
}
expect eof
EOF
    cat "${test_pamcom}" | grep -oE "密码少于 8 个字符|密码未通过字典检查|密码包含少于 3 的字符类型"
    CommRetParse_LTFLIB "设置超过3 位的字符类型、8个及8个以上字符且不包含用户名的密码没有警告" "False" "yes"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
