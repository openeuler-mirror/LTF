while read -r cert_file_name; do
# 使用 openssl 命令从证书中提取 Subject 的 CommonName 字段
# 该字段与 trust list 显示中的 label 一致
cert_subject="$(openssl x509 -in "${cert_file_name}" -noout -subject -nameopt multiline |
grep -w 'commonName' | awk -F '= ' '{print $2}')" || {
echo "Cannot parse ${cert_file_name}"
continue
}
# 获取证书的 Subject Key Identifier
subject_keyid="$(openssl x509 -in "${cert_file_name}" -noout -text |
grep -A1 "Subject Key Identifier" | tail -1 | tr -d '[:space:]')"
# 格式化 Subject Key Identifier 为 PKCS11 格式
# shellcheck disable=SC2001
subject_keyid_pki="$(echo "${subject_keyid//:/%}" | sed -e 's/.*/%&/g')"
# 如果 CommonName 包含 \U
if [[ "${cert_subject}" == *"\\U"* ]]; then
# 那么包含了中文字符，需要转义为中文字符
cert_subject="$(echo -e "${cert_subject//\\U/\\u}")"
fi
echo -e "Certificate file name: ${cert_file_name}"
echo -e "\tSubject: ${cert_subject}"
echo -e "\tSubject Key Identifier: ${subject_keyid}"
echo -e "\tCheck the system keystore:"
# 从系统密钥库中检查该证书是否存在，如果存在，则打印出相关信息
keystore_info="$(trust list | grep -i "${subject_keyid_pki}" -A4 | head -5)"
if [[ "${keystore_info}" ]]; then
while read -r keystore_info_line; do
# 打印出的 label 与证书的 Subject 一致
printf '\t\t%s\n' "${keystore_info_line}"
done < <(echo "${keystore_info}")
else
# 如果不存在，则打印不存在的提示信息
printf '\t\t%s\n' "The certificate was not found in the system keystore."
fi
echo
done < <(
# 查找所有国密根证书
find "/usr/share/pki/ca-trust-source/anchors/kylinsec/" \
-maxdepth 1 -type f -print0 | xargs -0 -n1
)
