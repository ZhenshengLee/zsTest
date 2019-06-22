#!/bin/sh
# 10222446, li.zhensheng@jetson.com.cn

# *****************************************************************************
# GIT REPO CONFIGURATIONS
#
# DIRQUEUE+="<git-name>&<rela-path> "
# use space if <rela-path> is current dir
# SPACE is Requierd!
# DIRQUEUE+="& "
# DIRQUEUE+="code/code&code/code "
# *****************************************************************************

# DIRQUEUE+="code/code&code/code "
DIRQUEUE+="& "

# *****************************************************************************
# DATE CONFIGURATIONS
#
# CONFIG_DATE_SINCE="<date>"
# CONFIG_DATE_UNTIL="<date>"
# <date> may be like 2018-05-31 or 3.weeks.ago
# Leave NULL if you do not want
# *****************************************************************************

CONFIG_DATE_SINCE="2018-01-20"
CONFIG_DATE_UNTIL=""

# *****************************************************************************
# EXTENSION CONFIGURATIONS
#
# CONFIG_EXT+="<git-name>&<rela-path> "
#
# COMMA is Requierd!
#
# CONFIG_EXT+="c,"
# CONFIG_EXT+="java,"
# *****************************************************************************

CONFIG_EXT+=**

# *****************************************************************************
# IGNORE CONFIGURATIONS
#
# CONFIG_IGNORE+="<ignore-filter> "
#
# SPACE is Requierd!
#
# CONFIG_IGNORE+="myfile "
# CONFIG_IGNORE+="file:myfile "
# CONFIG_IGNORE+="author:John "
# CONFIG_IGNORE+="email:@gmail.com "
# CONFIG_IGNORE+="revision:8755fb33 "
# CONFIG_IGNORE+="message:BUGFIX "
#
# file:switchdrv/jetson/drv/jetsonsdk/
# 需要以git库为基地址来写相对路径
# *****************************************************************************

CONFIG_IGNORE="revision:58061241f998d96d00a6a2b662101a6f810af527 "
