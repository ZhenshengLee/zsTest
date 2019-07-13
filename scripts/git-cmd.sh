#!/bin/bash

help()
{
    echo =========================================================================
    echo gitcmd.sh usage:
    echo " 参数说明："
    echo " ./gitcmd.sh 命令 路径 指定参数"
    echo " 命令1:clone \$Path \$UserName"
    echo " 命令2:cloneboot \$Path_boot \$UserName"
    echo " 命令3:reset \$Path \$Branch "
    echo " 命令4:setbranch \$Path \$Branch "
    echo " 命令5:getbranch \$Path "
    echo " 命令6:ln \$Path "
    echo " 命令7:\$Cmd \$Path "
    echo " 可选值：\$Branch:master "
    echo " \$Cmd: pull,status,diff..."
    echo " 默认值：\$Path: code \$UserName:ZhenshengLee \$Branch:master"
    echo "for example:"
    echo "用法一: 从github下载代码(主分支)"
    echo " 例1: gitcmd clone code #使用默认账号ZhenshengLee"
    echo " 例2: gitcmd clone zsTest ZhenshengLee #文件夹为zsTest, 使用账号ZhenshengLee下载"
    echo " 例3: gitcmd cloneboot zsBoot #使用默认账号ZhenshengLee"
    echo " 例4: gitcmd cloneboot zsBoot ZhenshengLee #文件夹为zsBoot, 使用账号ZhenshengLee下载"
    echo "用法二: 更新并覆盖代码"
    echo " 例1: gitcmd reset code #代码更新到最新,分支不改变"
    echo " 例2: gitcmd reset zsTest master #代码更新到最新,分支切换为master,文件夹为zsTest"
    echo "用法三: 切换分支"
    echo " 例1: gitcmd setbranch code master #切换分支"
    echo "用法四: 获取各git库的分支号"
    echo " 例1: gitcmd getbranch code #获取分支号"
    echo "用法五: 软连接"
    echo " 例1: gitcmd ln code #软连接"
    echo "用法六: 获取当前状态"
    echo " 例1: gitcmd status code #当前状态"
    echo "用法七: 版本回退"
    echo " 例1: gitcmd back code 20190713081644 #回退到2017年12月7日8时16分44秒"
    echo =========================================================================
    exit
}
gitdirdef()
{
    DIRQUEUE="zsBoot& "
    DIRQUEUE+="zsBsp& "
    DIRQUEUE+="zsConfig& "
    DIRQUEUE+="zsCppApp& "
    DIRQUEUE+="zsESamples& "
    DIRQUEUE+="zsQt& "
    DIRQUEUE+="zsROS2& "
    DIRQUEUE+="zsTest& "
    DIRQUEUE+="zsTrain& "
}

gitdirboot()
{
    DIRQUEUE="zsBoot& "
}

git@github.com:ZhenshengLee/zsCppApp.git
gitclone()
{
    for tmpdir in $DIRQUEUE
    do
        git clone git@github.com:"$PARAM_USER"/${tmpdir%%&*}.git "$PARAM_PATH"/"${tmpdir#*&}"
        sleep 1
    done
    echo "UserName:${PARAM_USER}"
}

gitsetbranch()
{
    for tmpdir in $DIRQUEUE
    do
        echo "${PARAM_PATH}/${tmpdir#*&}"
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        git checkout -f ${PARAM_BRANCH}
        cd "${CURRENT_PATH}"
        sleep 1
    done
    wait
    echo "Branch:${PARAM_BRANCH}"
}

gitgetbranch()
{
    for tmpdir in $DIRQUEUE
    do
        echo "${PARAM_PATH}/${tmpdir#*&}"
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        git branch -a
        cd "${CURRENT_PATH}"
    done
    wait
}

gitreset()
{
    for tmpdir in $DIRQUEUE
    do
        echo "${PARAM_PATH}/${tmpdir#*&}"
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        git checkout -f ${PARAM_BRANCH}
        git fetch --all
        git reset --hard origin/${PARAM_BRANCH}
        cd "${CURRENT_PATH}"
        sleep 1
    done
    wait
    echo "Branch:${PARAM_BRANCH}"
}

gitsetfilemode()
{
    for tmpdir in $DIRQUEUE
    do
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        git config core.filemode false
        cd "${CURRENT_PATH}"
    done
    wait
}

gitcmd()
{
    for tmpdir in $DIRQUEUE
    do
        echo "${PARAM_PATH}/${tmpdir#*&}"
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        git ${PARAM_CMD}
        cd "${CURRENT_PATH}"
        sleep 1
    done
    wait
    echo "Cmd:${PARAM_CMD}"
}

: '
#整块注释
'
#软连接必须绝对路径
gitln()
{
    echo "git-cmd gitln"
    CODEPATH="$CURRENT_PATH/$PARAM_PATH"/code
    : '
    XTNPATH="$CODEPATH"/xtn
    rm -f "$XTNPATH"/boot

    ln -s "$CODEPATH"/firmware/boot "$XTNPATH"/boot
    '
}

gitback()
{
    for tmpdir in $DIRQUEUE
    do
        echo "${PARAM_PATH}/${tmpdir#*&}"
        cd "$PARAM_PATH"/"${tmpdir#*&}"
        gitloglist=`git log --pretty=format:"%H %cd"`
        num=1
        for gitlog in $gitloglist
        do
            if [ "$num" = "1" ]
            then
                loghash="$gitlog"
            elif [ "$num" = "3" ]
            then
                logmouth="$gitlog"
            elif [ "$num" = "4" ]
            then
                logday="$gitlog"
                if [ "$logday" -le "9" ]
                then
                    logday="0${logday}"
                fi
            elif [ "$num" = "5" ]
            then
                logtime="$gitlog"
            elif [ "$num" = "6" ]
            then
                logyear="$gitlog"
                logmouth="${logmouth//Jan/01}"
                logmouth="${logmouth//Feb/02}"
                logmouth="${logmouth//Mar/03}"
                logmouth="${logmouth//Apr/04}"
                logmouth="${logmouth//May/05}"
                logmouth="${logmouth//Jun/06}"
                logmouth="${logmouth//Jul/07}"
                logmouth="${logmouth//Aug/08}"
                logmouth="${logmouth//Sep/09}"
                logmouth="${logmouth//Oct/10}"
                logmouth="${logmouth//Nov/11}"
                logmouth="${logmouth//Dec/12}"
                logdate="${logyear}${logmouth}${logday}${logtime:0:2}${logtime:3:2}${logtime:6:2}"
                if [ "$logdate" -le "$PARAM_DATE" ]
                then
                    echo "logdate:${logyear}${logmouth}${logday} ${logtime}"
                    git checkout -f $loghash
                    break
                fi
            elif [ "$num" = "7" ]
            then
                num=0
            fi
            num=`expr $num + 1`
        done

        cd "${CURRENT_PATH}"
        sleep 1
    done
    wait
}


gitchmoddef()
{
    echo "git-cmd gitchmoddef do nothing"
    # chmod -R 751 "$PARAM_PATH"/product
    # chmod -R 751 "$PARAM_PATH"/sup
}

gitchmodboot()
{
    echo "git-cmd gitchmodboot do nothing"
    # chmod -R 751 "$PARAM_PATH"/*
}


PARAM_NUM=$#

#PARAM_PATH="$2"
#PARAM_THIRD="$3"

#默认参数
PARAM_PATH="code"
PARAM_USER="ZhenshengLee"
CURRENT_PATH=`pwd`
PARAM_BRANCH="master"
PARAM_DATE="20190713081644"
URLTYPE="zs"

#参数赋值
if [ "$PARAM_NUM" -le 1 ]
then
    help
elif [ "$PARAM_NUM" -ge 2 ]
then
    PARAM_CMD="$1"
    PARAM_PATH="$2"
    if [ "$PARAM_CMD" = "cloneboot" ]
    then
        URLTYPE="boot"
    elif [ "$PARAM_CMD" = "clone" ]
    then
        URLTYPE="zs"
    else
        if [ -d "${PARAM_PATH}" ];then
            cd "${PARAM_PATH}"
            #git路径
            GIT_DIR=`git remote -v`
            echo "GIT_DIR:${GIT_DIR}"
            if [[ "$GIT_DIR" =~ "zxmp_boot" ]]
            then
                URLTYPE="boot"
            else
                URLTYPE="zs"
            fi
            #分支
            PARAM_BRANCH=`git branch -a`
            PARAM_BRANCH=`echo "$PARAM_BRANCH" | sed 'N;s/\n/ /'`
            PARAM_BRANCH=`echo ${PARAM_BRANCH#*\*}`
            PARAM_BRANCH="${PARAM_BRANCH%%\ *}"
            cd ../
        fi
    fi

fi



if [ "$PARAM_NUM" == 3 ]
then
    if [ "$PARAM_CMD" = "clone" ] || [ "$PARAM_CMD" = "cloneboot" ]
    then
        PARAM_USER="$3"
    elif [ "$PARAM_CMD" = "reset" ] || [ "$PARAM_CMD" = "setbranch" ]
    then
        PARAM_BRANCH="$3"
    elif [ "$PARAM_CMD" = "back" ]
    then
        PARAM_DATE="$3"
    else
        help
    fi
fi

#对参数进行修补完整
: '
if [[ "$PARAM_BRANCH" =~ "xxx" ]]
then
    PARAM_BRANCH="xxx"
elif [[ "$PARAM_BRANCH" =~ "xxx" ]]
then
    PARAM_BRANCH="xxx"
fi
'

if [[ "$URLTYPE" =~ "boot" ]]
then
    gitdirboot
else
    gitdirdef
fi

echo "[ PARAM_CMD ] ${PARAM_CMD}"
echo "[ PARAM_PATH ] ${PARAM_PATH}"
echo "[ PARAM_USER ] ${PARAM_USER}"
echo "[ PARAM_BRANCH ] ${PARAM_BRANCH}"


#处理命令
if [ "$PARAM_CMD" = "clone" ] || [ "$PARAM_CMD" = "cloneboot" ]
then
    gitclone
elif [ "$PARAM_CMD" = "reset" ]
then
    gitreset
elif [ "$PARAM_CMD" = "setbranch" ]
then
    gitsetbranch
elif [ "$PARAM_CMD" = "getbranch" ]
then
    gitgetbranch
elif [ "$PARAM_CMD" = "ln" ]
then
    if [ "$URLTYPE" != "boot" ]
    then
        gitln
    fi
elif [ "$PARAM_CMD" = "back" ]
then
    gitback
else
    gitsetfilemode
    gitcmd
fi

if [ "$URLTYPE" != "boot" ]
then
    # gitln
    gitchmoddef
else
    gitchmodboot
fi

gitsetfilemode
