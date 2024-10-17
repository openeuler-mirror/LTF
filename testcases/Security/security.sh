#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Filename:   security.sh
# Version:    1.0
# Date:       2019/12/05
# Author:     Lz
# Email:      lz843723683@163.com
# History：     
#             Version 1.0, 2019/12/05
# Function:   调用不同的安全测试程序
# In :        Security testcase name(testcase dir name)
# Out:        
#              0 => TPASS
#              1 => TFAIL
#              2 => TCONF
# ----------------------------------------------------------------------

# unbound exit
set -u

## TODO : 测试前的初始化验证 
#  In   : $1 => testcase dir name
#  Out  : 
#         0 => TPASS
#         1 => TFAIL
#         2 => TCONF
Init_SCRT(){
	local testdir="$1"
	local rootpath="$2"

	# 加载ltf库函数
	local ltflibfile="${LIB_LTFLIB}"
	if [ -f "$ltflibfile" ];then
		source $ltflibfile
	else
		TFail_LLE "$ltflibfile : Can't found file !"
		return 1
	fi

	export SEC_SRC_DIR_SEC="${rootpath}/src"
	if [ ! -d "$SEC_SRC_DIR_SEC" ];then
		TFail_LLE "$SEC_SRC_DIR_SEC: Can't found file !"
		return 1
	fi

	return ${TPASS}
}




## TODO ：运行当前目录中所有的可执行文件,Run Current Dir File,前提必须进入当前目录
#  In	：
#	  $1 => 目录名
#  Out  ： 
#         0=> TPASS
#         1=> TFAIL
#         other=> TCONF
RunCurDirFile_SCRT(){
	local testdir="$1"
    # 测试文件路径
    local testfile=""
	local flag="${TPASS}"
	local ret="${TPASS}"
	

    # 测试文件，通过数组保存
    local testfilelist=($(find ./ -maxdepth 1 -type f | sort))

    for testfile in ${testfilelist[*]}
    do
        [[ "$testfile" =~ "readme"|"swp" ]] && continue
        if [ -x "$testfile" ];then
            bash $testfile
            flag=$?
        else
			# 写阻塞日志文件
			echo "$(pwd)/${testfile}" >> ${LOG_CONF_FILE}
			OverallLog_LLE "${TCONF}" "${testfile#*/} : No executable permissions"

			# 禁止降级
			if [ $ret -ne $TFAIL ];then
				ret=${TCONF}
			fi

            continue
        fi

		OverallLog_LLE "${flag}" "${testdir}/${testfile#*/}"
		RetToFlag_LLE "${flag}" "${ret}"
		ret=$?

    done
	
	return $ret
}


## TODO : 执行测试
#  In   : $1=>testcase dir name
#  Out  : 
#         0=> TPASS
#         1=> TFAIL
#         other=> TCONF
Run_SCRT(){
	# 测试文件目录
	local testdir="$1"
	local ret_1="${TPASS}"
	local ret_2="${TPASS}"
	
	# 运行当前目录下的程序,如果运行当前目录，一定要判断去除kernel.sh脚本
	#RunCurDirFile_SCRT "$(basename $(pwd))"
	#ret_1=$?

	# 进入测试目录
	cd ${testdir}
	RunCurDirFile_SCRT "${testdir}"
	ret_2=$?

	# 结果过滤
	if [ $ret_1 -eq ${TFAIL} ];then
		return $ret_1
	elif [ $ret_1 -eq ${TPASS} ];then
		return $ret_2
	else
		if [ $ret_2 -eq ${TFAIL} ];then
			return $ret_2
		fi

		return $ret_1
	fi
}


## TODO : 垃圾回收
Clean_SCRT(){
	true
}


## TODO : 解析函数返回值
RetParse_SCRT(){
	local ret=$?
	if [ $ret -ne ${TPASS} ];then
		Clean_SCRT
		exit $ret
	fi
}


## TODO : main
#   In  : $1 => testcase dir name
#   Out : 0 => TPASS
#         1 => TFAIL
#         2 => TCONF
Main_SCRT(){
	local testdir=$(basename $1)
	local rootpath=$(dirname $1)
	cd ${rootpath}

	Init_SCRT "${testdir}" "${rootpath}"
	RetParse_SCRT

	Run_SCRT "${testdir}"
	RetParse_SCRT

	Clean_SCRT
	RetParse_SCRT

	return ${TPASS}
}

Main_SCRT $*
exit $?
