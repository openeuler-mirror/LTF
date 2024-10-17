#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   02-aslr.sh
# Version:    1.0
# Date:       2022/06/24
# Author:     Lz
# Email:      lz843723683@gmail.com
# History：
#             Version 1.0, 2022/06/24
# Function:   other - 其他安全功能测试 - ASLR特性测试
# Out:
#             0 => TPASS
#             1 => TFAIL
#             2 => TCONF
# ----------------------------------------------------------------------

Title_Env_LTFLIB="其他安全功能测试 - ASLR特性测试"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    aslr_name="aslr.c"
    aslr_file="${SEC_SRC_DIR_SEC}/aslr.c"
    cp "${aslr_file}" "${TmpTestDir_LTFLIB}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :aslr.c"

    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${TmpTestDir_LTFLIB}/aslr*"
    rm -rf ${TmpTestDir_LTFLIB}/aslr*
    return $TPASS
}

## TODO :
testcase_1() {
    # 编译
    local test_exe="${TmpTestDir_LTFLIB}/aslr"
    gcc -o "${test_exe}" "${TmpTestDir_LTFLIB}/${aslr_name}"

    local tmpstr=$(${test_exe})
    local tmpstrs="${tmpstr}"
    for i in $(seq 1 5); do
        tmpstr=$(${test_exe})
        echo ${tmpstr}
        echo ${tmpstrs} | grep ${tmpstr}
        if [ $? -eq 0 ]; then
            OutputRet_LTFLIB "${TFAIL}"
            TestRetParse_LTFLIB "地址值不具备随机性 history=${tmpstrs},cur=${tmpstr}"
        fi
        tmpstrs="${tmpstrs} ${tmpstr}"
    done

    OutputRet_LTFLIB "${TPASS}"
    TestRetParse_LTFLIB "地址值具备随机性: ${tmpstrs}"

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
