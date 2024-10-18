#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  16-gm_t_0003_support.sh
# Version	:  1.0
# Date		:  2024/09/30
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  操作系统支持GM/T 0003
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="操作系统支持GM/T 0003"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    tmp_dir="/tmp"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    Debug_LLE " rm -f priv.key pub.key readme.txt sm2.sig"
    rm -rf priv.key pub.key readme.txt sm2.sig
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

## TODO ： 测试操作系统支持GM/T 0003
#
testcase_1() {
    # 1. 生成 SM2 私钥
    cd ${tmp_dir}
    openssl ecparam -genkey -name SM2 -out priv.key
    CommRetParse_LTFLIB "生成 SM2 私钥：openssl ecparam -genkey -name SM2 -out priv.key"

    # 2. 生成 SM2 公钥
    openssl ec -in priv.key -pubout -out pub.key
    CommRetParse_LTFLIB "生成 SM2 公钥：openssl ec -in priv.key -pubout -out pub.key"

     # 3. 创建测试文件
    echo 'test_string' > readme.txt
    CommRetParse_LTFLIB "创建测试文件：echo 'test_string' > readme.txt"

     # 4. 使用SM2私钥对readme.txt文件进行签名
    openssl pkeyutl -sign -inkey priv.key -in readme.txt -out sm2.sig
    CommRetParse_LTFLIB "使用SM2私钥对readme.txt文件进行签名：openssl pkeyutl -sign -inkey priv.key -in readme.txt -out sm2.sig"

    # 5. 使用SM2公钥验证签名
    openssl pkeyutl -verify -pubin -inkey pub.key -in readme.txt -sigfile sm2.sig
    CommRetParse_LTFLIB "使用SM2公钥验证签名：openssl pkeyutl -verify -pubin -inkey pub.key -in readme.txt -sigfile sm2.sig"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
