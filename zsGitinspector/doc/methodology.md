# 基于git的代码分析-需求澄清

作者：黎振胜10222446

## 写在前面-澄清需求

### git中代码的归属问题

到底是归author还是committer？甚至是提交信息中的修改人？

其实只要提前定好规范，都行！

git config提前设置好

基于git的代码分析主要依赖git-log，获取提交信息，来判断该次提交所涉及的变更归哪位开发人员所有

### 对于变更中的代码，我们关注什么

* 我们关注包含大小括号，注释，换行在内的所有代码

WHY，读读CleanCode

大小括号，等涉及编码风格；注释涉及编码可读性；

所以我们统计

#### 代码变更统计-什么是变更

涉及代码风格的-算
涉及代码可读性的-算

换行算不算？---算
大小括号算不算---算

在代码后面加空格算不算变更-不算

删除算不算-算

### 基于Git的分析，以commit为最小单位

对于这次删除，下次添加的情况，怎么破？---这个解决不了

对于revert的代码,merge的代码，怎么破？---这个git可以解决---git提供接口

### 对于静态的代码，我们关注什么

我们关注注释量，重复程度，圈复杂度等度量指标

谁的代码最多---贡献度

关注某位作者提交代码的稳定性(提交后还保留下来的代码量)---如果一个人代码增了又删，那么他的代码是不稳定的

### 基于Git的分析是什么？

只有遵循Git版本管理规则的代码提交，才能够基于Git进行分析。

所以，对于这种需求：如果某作者的提交信息中包含"修改人：10222446"的提交，则该提交的代码纳入此作者的统计

首先不说该作者提交信息撰写的随意性对统计性能的影响（如这次写10222446，下次写lizhensheng，下次写zs）

涉及多个人的提交，应给提前分开提交！这才是基于git(或者所有版本控制系统)的代码提交规范

所以这种需求不予考虑。

## 原理介绍

准不准，肯定不准，之后给大家试用，再提需求

在具体规则下还是准的，上次已经跟xx演示过了

### 基本原理

git-log和git-diff

### git-inspector简介

## 使用说明

### config.sh

### .mailmap

## 关于准确性

### 肯定是不准的

自动化工作的准确性依赖信息的可分析性，如果信息本身是无章可循的，甚至是假的，那么准确性就会打折扣

时间段越短，准确度越高，粗大误差越容易排除

### 如何增加准确度

#### 时间段

#### 人工筛查

去除一些文件，去除一些提交，工具目前提供这个功能

#### 补偿

对于二进制文件，如bin，dat文件，给与一次变更多少行的补偿，

配置好git
