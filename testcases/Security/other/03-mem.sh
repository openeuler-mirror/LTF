#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   03-mem.sh
# Version:    1.0
# Date:       2022/06/24
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：
#             Version 1.0, 2022/06/24
# Function:   other - 其他安全功能测试 - 不可执行内存
# Out:
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="其他安全功能测试 - 不可执行内存"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    mem_name="mem_exec_test.c"
    mem_file="${SEC_SRC_DIR_SEC}/${mem_name}"
    cp "${mem_file}" "${TmpTestDir_LTFLIB}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :${mem_name}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${TmpTestDir_LTFLIB}/mem_exec_test*"
    rm -rf ${TmpTestDir_LTFLIB}/mem_exec_test*
    return $TPASS
}

## TODO :
testcase_1() {
    # 编译
    test_exe="${TmpTestDir_LTFLIB}/mem_exec_test"
    gcc "${mem_file}" -o "${test_exe}"

    local tmpstr=$(${test_exe})
    echo $tmpstr
    echo $tmpstr | grep "Allocate memory at .* Got memory exception at" >/dev/null
    CommRetParse_LTFLIB "内存设置为不可执行" "True"

    tmpstr=$(${test_exe} 1)
    echo $tmpstr
    echo $tmpstr | grep "Allocate memory at .* Set .* executable Execute at .*OK, return 56088" >/dev/null
    CommRetParse_LTFLIB "内存设置为可执行"

}

## TODO : 运行测试集
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
