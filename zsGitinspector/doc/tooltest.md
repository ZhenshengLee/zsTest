# 探索

## 基础知识

务必阅读git手册，重点了解git-log, git-diff, git-blame命令

## 功能验证和改进

### 使用的示例库

主要使用下面这个库

url = ssh://xxx

branch "xxx"

### 多用户的问题

```
1494381493|2017-05-10|bbe80c3dd45037e287693aa43db6287fea546881|xxx
1518577029|2018-02-14|74020df3d22e605a09f6f3fb8a1a8fb35f0cbdf7|xxx
```

是同一个人

```
1505721642|2017-09-18|8e34ad64ef1ace0a0dd70bb0e200511f49945526|xxx
1512034252|2017-11-30|2209c40615d2f0a7b3f12a7332bdb9e231309bdb|xxx
1510620014|2017-11-14|3246e4223f95dca0f3e91d1113c49d7bf1969244|xxx
```

是同一个人

```
git log --author="$(git config --get user.name)" --pretty=tformat: --numstat
```

三个名字怎么处理，事实证明最后一个已经涵盖了，因为git-log命令中author是支持正则表达式的，所以会涵盖前三种。

```
git log --author="xxx" --pretty=tformat: --numstat --since=2017-05-10
git log --author="xxx" --pretty=tformat: --numstat --since=2017-05-10
git log --author="xx" --pretty=tformat: --numstat --since=2017-05-10
git log --author="xxx" --pretty=tformat: --numstat --since=2017-05-10
```

以第四个命令为准
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py  --since=2017-05-10 -l .
注意：当前gitinspector统计指标比较少的原因是，进行了文件后缀过滤！


#### mailmap选项

.mailmap内容，注意一定要确保编码为utf-8

```
x
```

### 添加删除行准不准

git log --author="10222446" --since=2018-04-15 --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l -m -r --since=2018-04-15 .


### 时间日期怎么写

以tortoisGit的commit Date 为准
git log --author="10222446" --since=6.weeks.ago --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
git log --author="10222446" --since=2018-04-15 --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -
当天的提交是不考虑的，必须提前一天


### 考虑注释和空行：

注释删除算删除，验证了
空行添加（有空格），目前算添加，
git变更目前还不知道有没有考虑注释，现在看来只有静态数据
以tortoisGit的commit Date 为准
git log --author="10117832" --since=2018-04-13 --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -

/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-13 .
对注释的考虑在Y:\gitMetrics\gitinspector\gitinspector\comment.py


### 考虑注释：

git log --author="10222446" --since=2018-04-02 --until=2018-04-03 --pretty=tformat: --numstat
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-02 --until=2018-04-03 .
经验证，注释添加算添加
空行添加（无空格），目前也算添加，
git log --author="10222446" --since=2018-04-02 --until=2018-04-03 --pretty=tformat: --numstat -w --word-diff-regex=[^[:space:]]


### 考虑不同分支：

目前只是将merged去掉了，不同分支应该加起来就够了
不行，没有考虑到fork的情况，fork的分支有共同的历史记录，需要严格考虑时间节点，分别计算



考虑去掉一些作者，目录，文件
gitinspector -x myfile
gitinspector -x file:myfile
gitinspector -x author:John
gitinspector -x email:@gmail.com
gitinspector -x author:John,email:@gmail.com
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2017-08-21 --file-types=** -x file:./pm .



### 考虑文件类型（文件后缀）：

默认只支持一些常用类型，到product库中看看是否支持xml等
*为无后缀
cd ./609P/lzs609P/product/
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-23 --file-types=xml .
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-23 --file-types=xml,mak,csv,sdl,* .
```
[*] [0] [1] [2] [3] [BAT] [MAK] [MIB] [NOTES] [TXT] [XML] [ac] [am] [bak] [bash] [bat] [bcm] [bot] [c] [cache] [capz] [cbat] [cbproj] [cc] [cfg] [clw] [cmake] [cnsr] [cpp] [css] [csv] [ctpl] [def] [dfm] [dof] [dpr] [dsp] [dsw] [ede] [filters] [fns] [groupproj] [guess] [h] [hnsr] [hpp] [html] [in] [inc] [info] [info-1] [info-2] [info-3] [info-4] [ini] [java] [js] [json] [kmod] [l] [lib] [lnt] [local] [log] [lpp] [lst] [m4] [mak] [md] [mib] [mk] [ms] [orig] [pas] [pbxproj] [pdf] [php] [plg] [plist] [pre] [proc] [pump] [py] [rb] [rc] [right] [rules] [s] [sdl] [sh] [sln] [status] [sub] [svn-base] [target] [tcl] [termcap] [tests] [tex] [texi] [texinfo] [tmp] [top] [tpl] [txt] [user] [v2] [vbs] [vcproj] [vcxproj] [wpj] [wsp] [xbm] [xcconfig] [xml] [xsd] [y] [yang] [ypp] [zod]
```

### 考虑去掉某个提交：

/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-22 --file-types=xml -x revision:ed1c275d669f7a639fdb9abfa9128a172c32c0d8 .
gitinspector -x revision:8755fb33
gitinspector -x message:BUGFIX

### 考虑度量（其他信息）：

主要包括代码稳定性，圈复杂度和作者对文件的负责程度，就是修改的越多，越负责
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l -m -r --since=2018-04-22 .
git blame -n -w -L 88,91 pmncp/rm/cmdhandler/source/xtnrmcmdhandler.cpp

注意：不同选项导致的结果不同，是相同的！
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py --since=2017-05-10 -l -m .
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py --since=2017-05-10 -l -H .
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py --since=2017-05-10 -l -m -H -r .

### 多个库

```
cd ./LiZhensheng/WorkSpace/linecard609/dwb40/code/
/home/developer/LiZhensheng/gitMetrics/gitinspector/gitinspector.py -l --since=2018-04-13 .
```

