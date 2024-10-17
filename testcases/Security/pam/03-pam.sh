#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   03-pam.sh
# Version:    1.0
# Date:       2021/06/28
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：     
#             Version 1.0, 2021/06/28
# Function:   pam - 03 身份鉴别测试 - 鉴别信息安全性测试 
# Out:        
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------


Title_Env_LTFLIB="身份鉴别测试 - 鉴别信息安全性测试" 

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1_pam03="ltfpam03"
passwd1_pam03="olleH717.12.#$"
userip_pam03="localhost"
AddUserNames_LTFLIB="${testuser1_pam03}"
AddUserPasswds_LTFLIB="${passwd1_pam03}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB(){
	# 配置免密登录
	SshAuto_OneConfig_LTFLIB "${userip_pam03}" "${testuser1_pam03}" "${passwd1_pam03}"
	TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

        SshAuto_SetIpUser_LTFLIB "${userip_pam03}" "${testuser1_pam03}"
        TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

	shadow_pam03="/etc/shadow"	


	return $TPASS
}


## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB(){

	return $TPASS
}


## TODO :
testcase_1(){
	cat ${shadow_pam03} | grep "${testuser1_pam03}" 
	CommRetParse_LTFLIB "cat ${shadow_pam03} | grep \"${testuser1_pam03}\""

	local passwd_pam03=`cat ${shadow_pam03} | grep "${testuser1_pam03}"`
	echo ${passwd_pam03} | awk -F: '{print $2}'
	echo ${passwd_pam03} | awk -F: '{print $2}' | grep ${passwd1_pam03}
	CommRetParse_LTFLIB "${testuser1_pam03} 用户口令以密文形式保存" "True" "yes"
}


## TODO : 普通用户无权查看${shadow_pam03} 
testcase_2(){
	SshAuto_CmdDef_LTFLIB "cat ${shadow_pam03}" "no" "yes"
        TestRetParse_LTFLIB "普通用户 ${testuser1_pam03} 无权限查看文件 ${shadow_pam03}"
}


## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB(){
	testcase_1
	testcase_2

	return $TPASS
}


#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
