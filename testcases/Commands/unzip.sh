#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  unzip.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令unzip功能测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="unzip 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="unzip"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    # 创建临时文件和目录
    test_unzip="${TmpTestDir_LTFLIB}/test-unzip"
    echo "Test unzip" >${test_unzip}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_unzip}"

    test_zip="${TmpTestDir_LTFLIB}/test-unzip.zip"

    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_unzip}"
    rm -rf "${test_unzip}"
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    zip "${test_zip}" "${test_unzip}"
    # 使用unzip命令解压测试归档文件
    which expect &>/dev/null
    if [[ "$?" -ne 0 ]]; then
        echo "不存在命令: expect . 所以无法使用sudo login ${TESTUSER1_LOGIN}登录用户"
        echo "请手动安装expect命令相关包."
        return $TCONF
    fi

    expect &>/dev/null <<-EOF
	spawn unzip "${test_zip}" -d "${TmpTestDir_LTFLIB}"
	expect {
		"replace：" { send "y\n";}
	}
	expect eof
	EOF
    cat "${test_unzip}" | grep "Test unzip"
    CommRetParse_LTFLIB "cat "${test_unzip}" |grep Test unzip"
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
