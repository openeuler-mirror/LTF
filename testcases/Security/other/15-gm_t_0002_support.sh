#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  15-gm_t_0002_support.sh
# Version	:  1.0
# Date		:  2024/09/30
# Author	:  guoji
# Email		:  guoji@kylinsec.com.cn
# History	:
#
# Function	:  操作系统支持GM/T 0002
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="操作系统支持GM/T 0002"

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
    Debug_LLE " rm -f encrypt_file encryped_file.sm4 decrypt_file"
    rm -rf encrypt_file encryped_file.sm4 decrypt_file
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

## TODO ： 测试操作系统支持GM/T 0002
#
testcase_1() {
    # 1. 创建待加密文件
    cd ${tmp_dir}
    echo "1234abc" > encrypt_file
    CommRetParse_LTFLIB "创建待加密文件：echo \"1234abc\" > encrypt_file"

    # 2. 使用 SM4 算法加密
    openssl enc -SM4 -in encrypt_file -K f12aaaaaa888888888888888888888aa -iv f12aaaaaa888888888888888888888aa -out encryped_file.sm4
    CommRetParse_LTFLIB "使用 SM4 算法加密：openssl enc -SM4 -in encrypt_file -K f12aaaaaa888888888888888888888aa -iv f12aaaaaa888888888888888888888aa -out encryped_file.sm4"

    # 3. 使用 SM4 算法解密 encryped_file.sm4 文件
    openssl enc -d -SM4 -in encryped_file.sm4 -K f12aaaaaa888888888888888888888aa -iv f12aaaaaa888888888888888888888aa -out decrypt_file
    CommRetParse_LTFLIB "使用 SM4 算法解密 encryped_file.sm4 文件：openssl enc -d -SM4 -in encryped_file.sm4 -K f12aaaaaa888888888888888888888aa -iv f12aaaaaa888888888888888888888aa -out decrypt_file"

    # 4. 比较解密后的文件和加密前的文件
    difference=$(diff decrypt_file encrypt_file)
    CommRetParse_LTFLIB "比较解密后的文件和加密前的文件：diff decrypt_file encrypt_file"
    if [ "${difference}" == "" ]; then
        OutputRet_LTFLIB "${TPASS}"
        TestRetParse_LTFLIB "解密后的文件与加密前的文件一致"
    else
        OutputRet_LTFLIB "${TFAIL}"
        TestRetParse_LTFLIB "解密后的文件与加密前的文件不一致"
    fi

    # 5. 使用错误的 key 去解密文件
    openssl enc -d -SM4 -in encryped_file.sm4 -K f12aaaaaa888888888888888888888ab -iv f12aaaaaa888888888888888888888ab -out decrypt_file
    CommRetParse_LTFLIB "使用错误的密钥解密：openssl enc -d -SM4 -in encryped_file.sm4 -K f12aaaaaa888888888888888888888ab -iv f12aaaaaa888888888888888888888ab -out decrypt_file" "true" "yes"
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
