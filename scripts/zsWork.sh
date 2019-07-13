#!/bin/bash
# Program:
#   This shell is used by LiZhensheng
# Author:
set -e
help()
{
    echo "This shell can ONLY be used by LiZhensheng"
    echo "NOW SUPPORT:"
    echo "gitupdateRepo"
    echo "gitwork on/off"
    exit 1
}

PATH_NETCONF_NOTES="/d/E_DISK/Documents/SVNlib/NetConf-Notes"
PATH_ZHENSHENG_NOTES="/d/E_DISK/Documents/SVNlib/Zhensheng-Notes"
PATH_ZSOFFICE_NOTES="/d/E_DISK/Documents/zsOffice"
PATH_LEARNING_NOTES="/d/F_DISK/Learning"

svnupdate()
{
    cd $PATH_SDNLIB_SCRIPT
    svn update
    cd $PATH_HTPLIB_SCRIPT
    svn update
}
gitupdate61v5r2()
{
    cd $PATH_61V5R2_CODE
    ./git61v5r2.sh pull lzs61v5r2
}
gitupdate609p()
{
    cd $PATH_609P_CODE
    ./gitftnp.sh pull lzs609P
}
gitwork()
{
    test $# -eq 0 && log_error "invalid argument"
    "gitwork"$1 $PATH_NETCONF_NOTES $PATH_ZHENSHENG_NOTES $PATH_ZSOFFICE_NOTES $PATH_LEARNING_NOTES
}

gitworkoff()
{
    for path in "$@" do
    echo cd "$path"
    cd "$path" && git checkout zsEMPTY
    done
}

gitworkon()
{
    for path in "$@"     do
    echo cd "$path"
    cd "$path" && git checkout master
    done
}

log_error()
{
    echo error: "$*" && exit 1
}

# *****************************************************************************
# 检查参数，构造变量 # 参数全部预处理为小写字母
# *****************************************************************************
PARAM_NUM=$#
FIRST_PARAM="$1"
SECOND_PARAM="$2"
THIRD_PARAM="$3"
FIRST_PARAM_LOWER=$(echo "$FIRST_PARAM" | tr "[:upper:]" "[:lower:]")

# 默认参数
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

# 命令执行
if [ "$PARAM_NUM" == 0 ]; then help
else
    PARAM_CMD=$FIRST_PARAM_LOWER
    shift
    test "$PARAM_CMD" = "help" -o "$PARAM_CMD" = "-h" -o "$PARAM_CMD" = "--help" && help
    #处理命令
    echo "$PARAM_CMD" "$*" "$PARAM_CMD" "$*"
fi