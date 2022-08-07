#!/bin/bash
#sh add_extra_app_info.sh $BRANCH $VERSION $BUILD
#sh add_extra_app_info.sh dev_all 1.0.0 7251247

# 包来源分支
FullBranceName=$1
VERSION=$2
BUILD=$3
ShortBranceName=${FullBranceName##*/}
echo "ShortBranceName=$ShortBranceName"
sed -i '' "s/package unknow brance/${ShortBranceName}/g" app_info.json

# 版本号version+build/VersionCode
echo "------VERSION:${VERSION}"
echo "------BUILD:${BUILD}"
sed -i '' "s/package unknow version/${VERSION}/g" app_info.json
sed -i '' "s/package unknow buildNumber/${BUILD}/g" app_info.json

# 包创建时间
mmddHHMM=$(date "+%m.%d")" "$(date "+%H:%M") # 02.21 1506
#echo "------mmddHHMM:${mmddHHMM}"
sed -i '' "s/package unknow time/${mmddHHMM}/g" app_info.json

#cp app_info.json ../flutter_updateversion_kit/assets/data
app_info_dir_home="../flutter_updateversion_kit/assets"
if [ ! -d "$app_info_dir_home" ];then
mkdir $app_info_dir_home
#echo "assets文件夹创建成功"
#else
#echo "assets文件夹已经存在"
fi


app_info_dir="$app_info_dir_home/data"
if [ ! -d "$app_info_dir" ];then
mkdir $app_info_dir
#echo "assets/data文件夹创建成功"
#else
#echo "assets/data文件夹已经存在"
fi

fileName="app_info.json"
app_info_file_path=$app_info_dir/$fileNam
cp $fileName $app_info_file_path

