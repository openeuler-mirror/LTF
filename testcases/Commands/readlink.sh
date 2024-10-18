#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   Template 
# Version:    1.0
# Date:       2021/06/20
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：     
#             Version 1.0, 2021/06/20
# Function:   Template 功能验证
# Out:        
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="readlink 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="readlink"


## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB(){
	testfile="${TmpTestDir_LTFLIB}/testfile"
	linkfile="${TmpTestDir_LTFLIB}/linkfile"

	return $TPASS		
}


## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB(){
	rm -rf ${testfile} ${linkfile}

	return $TPASS		
}


## TODO : 测试用例
testcase_1(){
	touch ${testfile}
	CommRetParse_LTFLIB "创建文件 ${testfile}"

	ln -s ${testfile} ${linkfile} 
	CommRetParse_LTFLIB "ln -s ${testfile} ${linkfile}"

	readlink ${linkfile} | grep ${testfile}
	CommRetParse_LTFLIB "readlink ${linkfile} | grep ${testfile}"
	
	return $TPASS
}

## TODO : 测试用例集
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
