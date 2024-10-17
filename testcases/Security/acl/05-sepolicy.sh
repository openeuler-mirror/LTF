#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   05-sepolicy.sh
# Version:    1.0
# Date:       2023/12/22
# Author:     yyk
# Email:      yuyongkang@kylinsec.com.cn
# History：     
#             Version 1.0, 2023/12/22
# Function:   sepolicy - 05 系统安全要求 - 强制访问控制 
# Out:        
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------


Title_Env_LTFLIB="系统安全要求 - 强制访问控制"
HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

TESTFILE_SE05="/tmp/ltftestfile.ks"
TESTUSER_SE05="ltfse123"
PASSWD="qwer.2023"
USERIP="localhost"
AddUserNames_LTFLIB="${TESTUSER_SE05}"
AddUserPasswds_LTFLIB="${PASSWD}"
	
## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB(){
	# 判断是否打开SE
	local flag_se="Enforcing"
	getenforce | grep -q -i "${flag_se}"
	CommRetParse_FailDiy_LTFLIB ${TCONF} "Must be Selinux = enforcing"

	SshAuto_OneConfig_LTFLIB "${USERIP}" "${TESTUSER_SE05}" "${PASSWD}"
	TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

	SshAuto_SetIpUser_LTFLIB "${USERIP}" "${TESTUSER_SE05}"
	TestRetParse_LTFLIB "设置默认IP和用户名" "True " "no" "yes"

	return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB(){
	Debug_LLE "rm -rf ${TESTFILE_SE05}"
	rm -rf "${TESTFILE_SE05}"
	semanage fcontext -d -s user_u -t controled_t "/.*\.ks" > /dev/null 2>&1
	semodule -r control > /dev/null 2>&1
	semanage login -d -s user_u "${TESTUSER_SE05}" > /dev/null 2>&1

	return $TPASS
}

## TODO : 强制访问控制测试
testcase_1(){
	local control_pp="${SEC_SRC_DIR_SEC}/control.pp"

	Info_LLE "Command: semanage login -a -s user_u ${TESTUSER_SE05}"
	semanage login -a -s user_u "${TESTUSER_SE05}"
	CommRetParse_LTFLIB "user ${TESTUSER_SE05} add semanage" 

	Info_LLE "Command: semodule -i ${control_pp}"
	semodule -i "${control_pp}"
	CommRetParse_LTFLIB "add semodule"

	Info_LLE "Command: semanage fcontext -a -s user_u -t controled_t "/.*\.ks""
	semanage fcontext -a -s user_u -t controled_t "/.*\.ks"
	CommRetParse_LTFLIB "add semodule fcontext"
	
	SshAuto_CmdDef_LTFLIB "echo 123 > "${TESTFILE_SE05}"" "no" "no"
	TestRetParse_LTFLIB "创建文件 ${TESTFILE_SE05}" "False"
	
	SshAuto_CmdDef_LTFLIB "cat "${TESTFILE_SE05}"" "no" "no"
	TestRetParse_LTFLIB "未打标记访问文件 ${TESTFILE_SE05}" "False" "no"
	
	SshAuto_CmdDef_LTFLIB "restorecon -rvF "${TESTFILE_SE05}"" "no" "no"
	TestRetParse_LTFLIB "文件 ${TESTFILE_SE05}打标记" "False"
	
	SshAuto_CmdDef_LTFLIB "cat "${TESTFILE_SE05}"" "no" "no"
	TestRetParse_LTFLIB "访问文件 ${TESTFILE_SE05}" "False" "yes"
}

## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB(){
	testcase_1

	return $TPASS
}


#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
