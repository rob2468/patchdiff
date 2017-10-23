#!/usr/bin/env bash
set -x

OLDFILEPATH=$1 # 旧模块文件路径
NEWFILEPATH=$2 # 新模块文件路径

WORKSPACE=/tmp/patchdiff
TMPOLDFILEPATH=$WORKSPACE/patchdiff_a/
TMPNEWFILEPATH=$WORKSPACE/patchdiff_b/
TMPDIFFFILEPATH=$WORKSPACE/patchdiff_difffile.txt # diff文件临时存储路径

# 工作区
if [[ ! -d $WORKSPACE ]]; then
    mkdir $WORKSPACE
fi
cp -R $OLDFILEPATH $TMPOLDFILEPATH
cp -R $NEWFILEPATH $TMPNEWFILEPATH

# 生成diff文件
git diff $TMPOLDFILEPATH $TMPNEWFILEPATH > $TMPDIFFFILEPATH

# 计算patch -p选项的值
IFS='/'
part=($TMPOLDFILEPATH)
unset IFS
stripnum=${#part[@]}
# 相对路径处理
if [[ ! -z ${part[0]} ]]
then
    stripnum=$((stripnum + 1))
fi

# patch
patch -p$stripnum < $TMPDIFFFILEPATH

# 临时文件清理
rm -rf $WORKSPACE
