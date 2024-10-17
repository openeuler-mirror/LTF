#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   02-pam.sh
# Version:    1.0
# Date:       2022/06/23
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：     
#             Version 1.0, 2022/06/23
# Function:   pam - 02 身份鉴别测试 - 基于PAM的口令认证测试
# Out:        
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------


Title_Env_LTFLIB="身份鉴别测试 - 基于PAM的口令认证测试" 

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1_pam02="ltfpam02"
passwd1_pam02="olleH717.12.#$"
testuser2_pam02="ltfpam02-2"
passwd2_pam02="olleH717.12.#$"
userip_pam02="localhost"
AddUserNames_LTFLIB="${testuser1_pam02} ${testuser2_pam02}"
AddUserPasswds_LTFLIB="${passwd1_pam02} ${passwd2_pam02}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB(){
	# 配置免密登录
	SshAuto_OneConfig_LTFLIB "${userip_pam02}" "${testuser1_pam02}" "${passwd1_pam02}"
	TestRetParse_LTFLIB "配置免密登录" "True" "no" "yes"

        SshAuto_SetIpUser_LTFLIB "${userip_pam02}" "${testuser1_pam02}"
        TestRetParse_LTFLIB "设置默认IP和用户名" "True" "no" "yes"

	shadow_pam02="/etc/shadow"	

	return $TPASS
}


## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB(){

	return $TPASS
}


## TODO : 正确用户名密码登录，并且查看用户
testcase_1(){
	cat ${shadow_pam02} | grep "${testuser1_pam02}" 
	CommRetParse_LTFLIB "cat ${shadow_pam02} | grep \"${testuser1_pam02}\""
}


## TODO : 错误的用户和密码登录
testcase_2(){
	# 配置免密登录
	SshAuto_OneConfig_LTFLIB "${userip_pam02}" "${testuser2_pam02}" "${passwd2_pam02}fail"
	TestRetParse_LTFLIB "使用错误的密码,要求配置免密登录失败" "False" "yes"
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
