#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   01-audit.sh
# Version:    1.0
# Date:       2022/06/23
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：     
#             Version 1.0, 2022/06/23
# Function:   audit - 01 安全审计测试 - 审计管理功能测试
# Out:        
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------


Title_Env_LTFLIB="安全审计测试 - 审计管理功能测试" 

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

testuser1_audit01="ltfaudit01"
passwd1_audit01="olleH717.12.#$"
userip_audit01="localhost"
AddUserNames_LTFLIB="${testuser1_audit01}"
AddUserPasswds_LTFLIB="${passwd1_audit01}"

auditctl_opt_audit01="/tmp/testfile -p rwxa -k test_file"
## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB(){
		
	return $TPASS
}


## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB(){
	auditctl -l | grep "${auditctl_opt_audit01}" > /dev/null
	if [ $? -eq 0 ];then
		auditctl -W ${auditctl_opt_audit01}
	fi

	return $TPASS
}


## TODO : 
testcase_1(){
	local svcname="auditd"
	systemctl start ${svcname} 
	SvcActive_LTFLIB "isActive" "no" "${svcname}"
	TestRetParse_LTFLIB "已启动${svcname}服务"
}


## TODO :
testcase_2(){
	ausearch --input-logs -i | grep ${testuser1_audit01} | head -n 5
	CommRetParse_LTFLIB "可以查看到用户${testuser1_audit01}相关审计日志"
}

## TODO :
testcase_3(){
	auditctl -w ${auditctl_opt_audit01} 
	CommRetParse_LTFLIB "auditctl -w ${auditctl_opt_audit01}"

	auditctl -l
	auditctl -l | grep "${auditctl_opt_audit01}"
	CommRetParse_LTFLIB "auditctl -l"

	auditctl -W ${auditctl_opt_audit01}
	CommRetParse_LTFLIB "auditctl -W ${auditctl_opt_audit01}"
}


## TODO : 运行测试集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB(){
	testcase_1
	testcase_2
	testcase_3

	return $TPASS
}


#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
