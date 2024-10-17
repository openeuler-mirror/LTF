#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  route.sh
# Version	:  2.0
# Date		:  2024/04/22
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  常用命令route验证
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="route 功能测试"

# 本次测试涉及的命令
CmdsExist_Env_LTFLIB="route ip"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return ${TPASS}
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    # 删除临时路由
    route del -net "${ip_1}.${ip_2}.${ip_3}.0/${netmask}" gw "${ip_1}.${ip_2}.${ip_3}.1" &>/dev/null
    return ${TPASS}
}

## TODO : 测试用例
testcase_1() {
    # 添加临时路由并验证
    local ip_1=$(ip addr show | grep "dynamic" | awk '{print $2}' | cut -d'.' -f1)
    local ip_2=$(ip addr show | grep "dynamic" | awk '{print $2}' | cut -d'.' -f2)
    local ip_3=$(ip addr show | grep "dynamic" | awk '{print $2}' | cut -d'.' -f3)
    local netmask=$(ip addr show | grep "${ip_1}.${ip_2}.${ip_3}" | awk '{print $2}' | cut -d'/' -f2)
    route add -net "${ip_1}.${ip_2}.${ip_3}.0/${netmask}" gw "${ip_1}.${ip_2}.${ip_3}.1" &>/dev/null
    CommRetParse_LTFLIB "route add -net ${ip_1}.${ip_2}.${ip_3}.0/${netmask} gw ${ip_1}.${ip_2}.${ip_3}.1 &>/dev/null"

    route -n | grep "${ip_1}.${ip_2}.${ip_3}.1"
    CommRetParse_LTFLIB "route -n|grep ${ip_1}.${ip_2}.${ip_3}.1"
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
