# 未来工作

## 软件功能

### debug中显示某条提交记录的增删信息

目前有一个办法可输出
/home/developer/LiZhensheng/gitMetrics/script/gitjetson.sh log dwb40

git log --author="邓文博10090301" --since=2017-08-22 --pretty=tformat: --numstat | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -

### 添加不同级别的调试信息

## 准确度提升

### 考虑不同分支的代码统计

tortoiseGit有一个显示所有分支的选项，看看能不能借用原理

### 单次提交超过3000行的不纳入统计

鼓励先添加现成文件，提交，再进行修改。这样自己的工作也可以统计其中

在输出脚本中修改

### 增加的文件不考虑进统计

这个是否符合需求还要讨论

### 对于某人不考虑某特性的提交

如对于邓文博，ADD的文件不纳入统计

不过，其实最好是如果不统计，大家都不统计

### 输出一个xls文件

在output模块添加

## 功能扩充

### 支持代码度量

在gitInspector基础上完善

### 集成到jenkins

输出一个网页，由jenkins读取



gitinspector与jenkins的结合
对象改造与项目维护

commit 类中加入依附在此commit中的文件列表和增删信息？
comment类中加入blankline统计

metrics只计算时间范围内的文件的度量信息，可以实现的，输出一个时间范围内的文件目录即可！

timeline数据生成统计图


建立一个py脚本读取xml信息，写入EXCEL
设置多次输出方案，生成多个文件
输出更多信息到TEXT和XML
首先输出到text，然后转化到XML或者JSON


自定义生成的html格式和所需信息
