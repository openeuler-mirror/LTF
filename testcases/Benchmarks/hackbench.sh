#!/bin/bas

## TODO: 搭建运行环境
##
HackbenchSetup(){
	# 工具名称,需要和XML文件中CaseName一致
	local toolName="hackbench"
	# 运行结果保存文件名
	hackbenchRetName="${toolName}.ret"
	# 源结果路径.若存在于解压包中，可以用":"代替
	local toolOrigRetDir="/opt/ltp"
	# 源结果文件或目录名 
	local toolOrigRetName="${hackbenchRetName}"
	
	# 加载benchmark工具函数
	source $(dirname $0)/lib/benchmark.sh
	
	# 注册函数
	RegisterFunc_BHK "HackbenchInit" "HackbenchInstall" "HackbenchRun"
	
	# 注册变量
	RegisterVar_BHK "${toolName}" "${toolOrigRetDir}" "${toolOrigRetName}"
}


## TODO: 个性化,安装前检查
## Out : 0=>TPASS
##	 1=>TFAIL
##       2=>TCONF
##
HackbenchInit(){
	local ret=0

        # 获取CPU个数
        tmpCpuNum=0
        GetCpuNum_BHK "tmpCpuNum"
        [ $? -ne 0 ] && { echo "无法获取有效的CPU个数";ret=2; }
        unset -v tmpCpuNum

	return $ret
}


## TODO：安装测试工具
## Out :0=>TPASS
##	1=>TFAIL
##      2=>TCONF
HackbenchInstall(){
	local ret=0
       
        # 获取CPU个数
        tmpCpuNum=0
        GetCpuNum_BHK "tmpCpuNum"
        [ $? -ne 0 ] && { echo "无法获取有效的CPU个数";return 2; }
        local cpuNum=${tmpCpuNum}
        unset -v tmpCpuNum
        echo "当前CPU的个数: ${cpuNum}" 

	# 配置
	./configure
	[ $? -ne 0 ] &&  return 1

	#编译
	if [ "$cpuNum" -gt "1" ];then
		make 
	else
		make -j ${cpuNum}
	fi
	[ $? -ne 0 ] &&  return 1

	#安装
	make install
	[ $? -ne 0 ] &&  return 1
	
	#判断是否存在hackbench
	if [ ! -f "/opt/ltp/testcases/bin/hackbench" ];then
		echo "Can't find /opt/ltp/testcases/bin/hackbench "
		return 1
	fi

	return $ret
}

## TODO：运行测试
##
HackbenchRun(){
	cd /opt/ltp/
	
	./runltp -f sched -s hackbench | tee ${hackbenchRetName} 

	cd -
}


main(){
	# 加载benchmark.sh文件
	HackbenchSetup

	# 调用主函数
	Main_BHK $@
}

main $@

exit $?
