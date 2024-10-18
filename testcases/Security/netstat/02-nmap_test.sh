#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  02-nmap_test.sh
# Version	:  2.0
# Date		:  2024/04/15
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#              Version 2.0, 2024/04/15
# Function	:  安全测试/系统默认端口测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="安全测试/系统默认端口测试"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    test_file="${TmpTestDir_LTFLIB}/nmap_file.txt"
    echo "test ${test_file}" >${test_file}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${test_file}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${test_file}"
    rm -rf ${test_file}
    return $TPASS
}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    return $TPASS
}

## TODO : 打开的端口与通信矩阵保持一致
testcase_1() {
    # 定义需要检查的端口范围
    local specific_ports=(22 53 67 323 111 68 5353)
    local port_range_start=1024
    local port_range_end=65535
    local status_flag="TURE"
    nmap -p- localhost | grep "open" | awk -F '/' '{print $1}' >"${test_file}"
    # 初始化一个空数组
    declare -a lines_array

    # 记录当前行数
    line_num=0

    # 使用while循环逐行读取文件
    while IFS= read -r line; do
        # 将当前行添加到数组中
        lines_array[line_num]="$line"
        # 更新行数
        ((line_num++))
    done <"${test_file}"

    # 遍历open_port_array，检查每个端口是否符合要求
    for port in "${lines_array[@]}"; do
        echo "遍历已开放端口$port"
        # 判断端口是否在特定单个端口列表内
        if [[ ! " ${specific_ports[*]} " =~ " $port " ]]; then
            # 若不在，进一步判断是否在连续端口范围内
            if ((port < port_range_start || port > port_range_end)); then
                netstat -nultp | grep "${port}"
                local status_flag="TFAIL"
            fi
        fi
    done
    if [[ ${status_flag} == "TFAIL" ]]; then
        OutputRet_LTFLIB ${TFAIL}
        TestRetParse_LTFLIB "打开的端口与通信矩阵保持不一致"
    else
        OutputRet_LTFLIB ${TPASS}
        TestRetParse_LTFLIB "打开的端口与通信矩阵保持一致"
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
