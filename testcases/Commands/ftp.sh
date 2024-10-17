#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  ftp.sh
# Version	:  2.0
# Date		:  2024/04/19
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令ftp验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="ftp 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="ftp vsftpd"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    sed -i "s/anonymous_enable=NO/anonymous_enable=YES/g" "/etc/vsftpd/vsftpd.conf"
    systemctl restart "vsftpd"
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    systemctl stop "vsftpd"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 匿名连接本地FTP服务器
    which expect &>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "不存在命令: expect.请手动安装expect命令相关包."
        return $TCONF
    fi
    expect &>/dev/null <<-EOF
	spawn sudo ftp localhost
	expect {
		"Name" { send "anonymous\n";exp_continue}
        "Password" { send "\n"}
	}
	expect eof
	EOF
    if [[ "$?" -eq 0 ]]; then
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "ftp localhost"
    else
        OutputRet_LTFLIB ${TFAIL}
        TestRetParse_LTFLIB "ftp localhost"
    fi
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
