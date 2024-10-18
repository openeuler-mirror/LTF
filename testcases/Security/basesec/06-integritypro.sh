#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename	:  06-integritypro.sh
# Version	:  2.0
# Date		:  2024/05/07
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# Function	:  完整性保护
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="完整性保护"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    yum_file="/etc/yum.repos.d/kylinsec.repo"
    cp "${yum_file}" "${yum_file}.bakltf"
    # 检查gpgcheck是否已经设置为1
    gpgcheck_st=$(grep -q "^gpgcheck=1$" "${yum_file}")
    if [[ ! "${gpgcheck_st}" ]]; then
        sed -i '/^gpgcheck=/s/=.*$/=1/' "${yum_file}"
        Info_LLE "gpgcheck has been set to 1 in ${yum_file}."
    fi
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    rm -rf "${yum_file}"
    mv "${yum_file}.bakltf" "${yum_file}"
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

## TODO : 完整性保护
testcase_1() {
    cat "/etc/yum.conf" | grep "gpgcheck=1"
    CommRetParse_LTFLIB "cat /etc/yum.conf |grep gpgcheck=1"
    cat "${yum_file}" | grep "gpgcheck=1"
    CommRetParse_LTFLIB "cat "${yum_file}"|grep gpgcheck=1"
    cat "${yum_file}" | grep "gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-kylinsec-release"
    CommRetParse_LTFLIB "cat ${yum_file} | grep gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-kylinsec-release"
    echo "y" | yum install -y vsftp* >/dev/null
    rpm -qa | grep vsftp*
    CommRetParse_LTFLIB "rpm -qa|grep vsftp*"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
