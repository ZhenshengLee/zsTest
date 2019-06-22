#!/bin/sh
# Program:
#   This shell is the entry of zsInspector, a python-based tool to analyze git repo
#   This is tool is originally derived from gitinspector from Ejwa Software in github
# Author:
#   First created in 2018-05-30, by lizhensheng, zhensheng@outlook.com
# ChangeLog:
#   - 2018-05-30    create the file
# Readme:
#   ./readme.md
# Tutorial:
#   ./tutorial.md

help() {
    echo =========================================================================
    echo zsInspector.sh [PATH] [CONFIG] [RUN]
    echo "参数说明："
    echo "  参数            含义            可选值              默认值"
    echo "  PATH:         仓库根目录          -                   .  "
    echo "  CONFIG:      项目配置项      jz2440|jetsonnano|none        none "
    echo "  RUN:          运行选项         normal|dry|debug     normal "
    echo "仓库根目录："
    echo "  请使用相对路径，而不是绝对路径"
    echo "配置项说明："
    echo "  通过配置项订制脚本行为，主要包括定义git目录，作者邮件映射等信息"
    echo "  首次使用请参考tutorial.md进行配置"
    echo "运行选项说明："
    echo "  normal: 一般运行"
    echo "  dry: 模拟运行"
    echo "  debug: 真实运行，输出调试信息"
    echo "example:"
    echo "    cd ./gitspace "
    echo "    zsInspector.sh ."
    echo =========================================================================
    exit 1
}

# *****************************************************************************
# config.sh, 包括以下变量的预定义
# DIRQUEUE
# CONFIG_DATE
# CONFIG_EXT
# CONFIG_IGNORE
# CONFIG_DATE_SINCE
# CONFIG_DATE_UNTIL
# *****************************************************************************

source_config() {
    source ./config/$1/config.sh
}

# *****************************************************************************
# 关于运行选项，主要是为了调试和查看
# dry: 模拟运行，只echo
# normal: 最少调试信息，真实运行
# debug: 最多调试信息，真实运行
# debug的日志应该包含dry
# *****************************************************************************

log_normal() {
    test "$PARAM_RUN" = "normal" && echo info: $* || return 1
}

log_verbose() {
    log_normal $* || echo debug: $*
}

log_error() {
    echo error: $* && exit 1
}

# *****************************************************************************
# 检查参数，构造变量
# 参数全部预处理为小写字母
# *****************************************************************************

set -e

PARAM_NUM=$#
FIRST_PARAM="$1"
SECOND_PARAM="$2"
THIRD_PARAM="$3"
FIRST_PARAM_LOWER=$(echo "$FIRST_PARAM" | tr "[:upper:]" "[:lower:]")
SECOND_PARAM_LOWER=$(echo "$SECOND_PARAM" | tr "[:upper:]" "[:lower:]")
THIRD_PARAM_LOWER=$(echo "$THIRD_PARAM" | tr "[:upper:]" "[:lower:]")

# 默认参数
PARAM_PATH="."
PARAM_PRJ="none"
PARAM_RUN="normal"

SHELL_FOLDER=$(
    cd "$(dirname "$0")"
    pwd
)

# 参数初步处理
if [ "$PARAM_NUM" == 0 ]; then
    log_verbose Make sure that options from ./config/$PARAM_PRJ/config.sh are what you want
elif [ "$PARAM_NUM" == 1 ]; then
    PARAM_PATH=$FIRST_PARAM_LOWER
    test "$PARAM_PATH" = "help" -o "$PARAM_PATH" = "-h" -o "$PARAM_PATH" = "--help" && help
elif [ "$PARAM_NUM" == 2 ]; then
    PARAM_PATH=$FIRST_PARAM_LOWER
    PARAM_PRJ=$SECOND_PARAM_LOWER
elif [ "$PARAM_NUM" == 3 ]; then
    PARAM_PATH=$FIRST_PARAM_LOWER
    PARAM_PRJ=$SECOND_PARAM_LOWER
    PARAM_RUN=$THIRD_PARAM_LOWER
else
    help
fi

source $SHELL_FOLDER/config/$PARAM_PRJ/config.sh

echo zsInspector $PARAM_PATH $PARAM_PRJ $PARAM_RUN

# 对参数进行修补完整
# if [[ "$PARAM_BRANCH" =~ "040" ]]
# then
#     PARAM_BRANCH="jetson_v1.00_040chip"
# elif [[ "$PARAM_BRANCH" =~ "cmcc" ]]
# then
#     PARAM_BRANCH="jetson_v1.00_cmccTest"
# fi

# *****************************************************************************
# 构造目录
# 检查目录是否是git仓库
# 复制.mailmap文件到git仓库
# ${tmpdir%%&*} 是git地址
# ${tmpdir#*&} 是代码目录地址
# *****************************************************************************

for tmpdir in $DIRQUEUE; do
    test -d $PARAM_PATH/${tmpdir#*&}/.git && cp $SHELL_FOLDER/config/$PARAM_PRJ/.mailmap $PARAM_PATH/${tmpdir#*&} || log_error Copy .mailmap failed, please check $PARAM_PATH/${tmpdir#*&}!
done

# *****************************************************************************
# 执行gitinspector命令
# *****************************************************************************

INSPECT_PATH=""
INSPECT_DATE_SINCE="--since="$CONFIG_DATE_SINCE
INSPECT_DATE_UNTIL="--until="$CONFIG_DATE_UNTIL
INSPECT_EXT="--file-types="$CONFIG_EXT
INSPECT_IGNORE=""
CURRENT_PATH=$(pwd)
CURRENT_FOLDER=${CURRENT_PATH##*/}

for tmpdir in $DIRQUEUE; do
    if [ "${tmpdir#*&}" == "" ]; then
        INSPECT_PATH+=". "
    else
        INSPECT_PATH+="${tmpdir#*&} "
    fi
done

for tmpignore in $CONFIG_IGNORE; do
    INSPECT_IGNORE+="-x "$tmpignore" "
done

echo $SHELL_FOLDER/gitinspector/gitinspector.py -l --format=xlsx $INSPECT_DATE_SINCE $INSPECT_DATE_UNTIL $INSPECT_EXT $INSPECT_IGNORE $INSPECT_PATH
$SHELL_FOLDER/gitinspector/gitinspector.py -l --format=xlsx $INSPECT_DATE_SINCE $INSPECT_DATE_UNTIL $INSPECT_EXT $INSPECT_IGNORE $INSPECT_PATH

wait

# *****************************************************************************
# 清除
# 目前主要删除之前复制的文件
# *****************************************************************************

for tmpdir in $DIRQUEUE; do
    test -e $PARAM_PATH/${tmpdir#*&}/.mailmap && rm $PARAM_PATH/${tmpdir#*&}/.mailmap || log_error Rm failed, please check $PARAM_PATH/${tmpdir#*&}!
done
