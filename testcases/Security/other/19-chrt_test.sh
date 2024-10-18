#!/usr/bin/env bash
# ----------------------------------------------------------------------
# Filename	:  19-chrt_test.sh
# Version	:  1.0
# Date		:  2024/10/10
# Author	:  yaoxiyao
# Email		:  yaoxiyao@kylinsec.com.cn
# History	:
#
# Function	:  使用实时进程卡死测试
# Out		:
#              0 => TPASS
#              1 => TFAIL
#              other=> TCONF
# ----------------------------------------------------------------------

# 测试主题
Title_Env_LTFLIB="使用实时进程卡死测试"

## TODO : 个性化,初始化
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestInit_LTFLIB() {
    return $TPASS
}

## TODO : 清理函数
#   Out : 0=>TPASS
#         1=>TFAIL
#         2=>TCONF
TestClean_LTFLIB() {
    # Debug_LLE "rm -rf /etc/systemd/system/realtime.slice"
    # rm -rf /etc/systemd/system/realtime.slice
    # Debug_LLE "rm -rf /etc/systemd/system/realtime-config.service"
    # rm -rf /etc/systemd/system/realtime-config.service
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

## TODO ： 使用实时进程卡死测试
#
testcase_1() {
    # 创建 realtime.slice
    cat >/etc/systemd/system/realtime.slice <<EOF
[Unit]
Description=Real Time Slice
Before=slices.target
Requires=realtime-config.service
[Slice]
CPUAccounting=yes
[Install]
WantedBy=slices.target
EOF

    CommRetParse_LTFLIB "创建 realtime.slice 文件"

    # 创建 realtime-config.service
    cat >/etc/systemd/system/realtime-config.service <<EOF
[Unit]
Description=Real Time Slice configuration service
BindsTo=realtime.slice
After=realtime.slice
[Service]
Type=oneshot
ExecStart=/bin/sh -c "/usr/sbin/sysctl -n kernel.sched_rt_runtime_us > /sys/fs/cgroup/cpu/realtime.slice/cpu.rt_runtime_us"
RemainAfterExit=yes
EOF

    CommRetParse_LTFLIB "创建 realtime-config.service 文件"

    # 重新加载 systemd 守护进程
    systemctl daemon-reload
    CommRetParse_LTFLIB "systemctl daemon-reload"

    # 启动 realtime.slice 服务
    systemctl restart realtime.slice
    CommRetParse_LTFLIB "systemctl restart realtime.slice"

    # 运行实时进程
    local archtype=$(arch)
    if [ "${archtype}" == "x86_64" ]; then
        systemd-run --remain-after-exit --slice=realtime.slice -P chrt 99 /lib
        if [ "$?" == "126" ]; then
            OutputRet_LTFLIB "${TPASS}"
            TestRetParse_LTFLIB "systemd-run --remain-after-exit --slice=realtime.slice -P chrt 99 /lib"
        else
            OutputRet_LTFLIB "${TFAIL}"
            TestRetParse_LTFLIB "systemd-run --remain-after-exit --slice=realtime.slice -P chrt 99 /lib"
        fi
    else
        Info_LLE "当前架构为$(arch)，不支持自动化测试，手工执行以下命令返回值是126即可："
        Info_LLE "systemd-run --remain-after-exit --slice=realtime.slice -P chrt 99 /lib"
    fi
}

#----------------------------------------------#

source "${LIB_LTFLIB}"
Main_LTFLIB $@
