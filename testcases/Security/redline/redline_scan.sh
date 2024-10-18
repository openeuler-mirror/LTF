#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  redline
# Version	:  1.0
# Date		:  2024/04/09
# Author	:  wzc
# Email		:  wuzhichao@kylinos.com.cn
# History	:
#              Version 1.0, 2024/04/09
# Function	:  安全红线全局扫描
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="安全红线扫描"

HeadFile_Source_LTFLIB="${LIB_SSHAUTO}"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    hard_code="${LOG_PATH}/hard_code.csv"
    touch ${hard_code}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${hard_code}"
    public_url="${LOG_PATH}/public_url.csv"
    touch ${public_url}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${public_url}"
    plaintext_passwd="${LOG_PATH}/plaintext_passwd.csv"
    touch ${plaintext_passwd}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${plaintext_passwd}"
    cipher="${LOG_PATH}/cipher.csv"
    touch ${cipher}
    CommRetParse_FailDiy_LTFLIB ${ERROR} "创建文件失败${cipher}"
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
	
    return $TPASS

}

## TODO : 测试用例集
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
Testsuite_LTFLIB() {
    testcase_1
    testcase_2
    testcase_3
    testcase_4
    return $TPASS
}

## TODO ： 安全红线匹配硬编码口令
#
testcase_1() {
    #关键字匹配文件
    local keywordpath="${SEC_SRC_DIR_SEC}/hard_passwd.txt"
    local dirpath="/"
    while IFS=" " read -r line;
    do
        Info_LLE "匹配的关键字为${line}"
	grep -EInri --exclude-dir=LTF "${line}" "${dirpath}" 2>/dev/null >> "${hard_code}"
        Info_LLE "grep -EInri '${line}' '${dirpath}' 2>/dev/null >> ${hard_code}"
    done < "${keywordpath}"
    CommRetParse_LTFLIB "匹配CSV文件已保存在${hard_code}"


}

## TODO ： 安全红线匹配公网地址
#

testcase_2() {
    #关键字匹配文件
    local keywordpath="${SEC_SRC_DIR_SEC}/public_url.txt"
    local dirpath="/"
    while IFS=" " read -r line;
    do
        Info_LLE "匹配的关键字为${line}"
        grep -EInri --exclude-dir=LTF "${line}" "${dirpath}" 2>/dev/null >> "${public_url}"
        Info_LLE "grep -EInri '${line}' '${dirpath}' 2>/dev/null >> ${public_url}"
    done < "${keywordpath}"
    CommRetParse_LTFLIB "匹配CSV文件已保存在${public_url}"


}

## TODO ： 安全红线匹配password敏感词
#

testcase_3() {
    #关键字匹配文件
    local keywordpath="${SEC_SRC_DIR_SEC}/plaintext_passwd.txt"
    local dirpath="/"
    while IFS=" " read -r line;
    do
        Info_LLE "匹配的关键字为${line}"
        grep -EInri --exclude-dir=LTF "${line}" "${dirpath}" 2>/dev/null >> "${plaintext_passwd}"
	Info_LLE "grep -EInri '${line}' '${dirpath}' 2>/dev/null >> ${plaintext_passwd}"
    done < "${keywordpath}"
    CommRetParse_LTFLIB "匹配CSV文件已保存在${plaintext_passwd}"


}

## TODO ： 安全红线匹配加密算法
#

testcase_4() {
    #关键字匹配文件
    sshd -T |egrep 'ciphers' 2>/dev/null >> "${cipher}"
    Info_LLE "sshd -T |egrep 'ciphers' 2>/dev/null >> ${cipher}"
    CommRetParse_LTFLIB "匹配CSV文件已保存在${cipher}"


}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@

