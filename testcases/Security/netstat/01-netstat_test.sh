#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  netstat_test
# Version	:  1.0
# Date		:  2023/12/21
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinos.com.cn 
# History	:     
#              Version 1.0, 2023/12/21
# Function	:  端口扫描
# Out		:        
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="系统安全要求 - 端口扫描"

NETNAME_LTF_NETSTAT="dns|sshd|Active|Program"

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


## TODO ： 查看是否仅开启dns和ssh的端口
# 
testcase_1(){
    Info_LLE "netstat -nutlp|grep -vE ${NETNAME_LTF_NETSTAT}"
    netstat -nutlp|grep -vE "${NETNAME_LTF_NETSTAT}"
    CommRetParse_LTFLIB "仅开启dns和ssh的端口" "Flase" "yes"
}


#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
