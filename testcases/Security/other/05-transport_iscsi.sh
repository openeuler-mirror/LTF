#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  05-transport_iscsi.sh
# Version	:  2.0
# Date		:  2024/05/10
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  x86_64有scsi_transport_iscsi内核模块漏洞
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="x86_64有scsi_transport_iscsi内核模块漏洞"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    tmp_dir="/tmp"
    iscs_name="2021.03.12-linux-iscsi.tar.bz2"
    iscs_file="${SEC_SRC_DIR_SEC}/${iscs_name}"
    cp "${iscs_file}" "${TmpTestDir_LTFLIB}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :${iscs_name}"

    iscs_shname="a.sh"
    iscs_shfile="${SEC_SRC_DIR_SEC}/${iscs_shname}"
    cp "${iscs_shfile}" "${tmp_dir}"
    CommRetParse_FailDiy_LTFLIB ${ERROR} "No such file :${iscs_shname}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE "rm -rf ${tmp_dir}/${iscs_shname} ${TmpTestDir_LTFLIB}/2021.03.12-linux-iscsi ${TmpTestDir_LTFLIB}/${iscs_name}"
    rm -rf "${TmpTestDir_LTFLIB}/2021.03.12-linux-iscsi" "${TmpTestDir_LTFLIB}/${iscs_name}"
    rm -rf "${tmp_dir}/${iscs_shname}"
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

## TODO ： x86_64有scsi_transport_iscsi内核模块漏洞
#
testcase_1() {
    tar -jxvf "${TmpTestDir_LTFLIB}/${iscs_name}" -C "${TmpTestDir_LTFLIB}" >/dev/null
    CommRetParse_LTFLIB "tar -jxvf ${TmpTestDir_LTFLIB}/${iscs_name} -C ${TmpTestDir_LTFLIB}"
    cd "${TmpTestDir_LTFLIB}/2021.03.12-linux-iscsi"
    CommRetParse_LTFLIB "cd ${TmpTestDir_LTFLIB}/2021.03.12-linux-iscsi"
    make >/dev/null
    CommRetParse_LTFLIB "make"
    chmod +x "${tmp_dir}/${iscs_shname}"
    CommRetParse_LTFLIB "chmod +x ${tmp_dir}/${iscs_shname}"
    for i in {1..3}; do
        ./exploit | grep "Failed to read an iscsi driver handle"
        CommRetParse_LTFLIB "./exploit | grep Failed to read an iscsi driver handle"
    done
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
