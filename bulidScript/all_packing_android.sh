#!/bin/bash
#sh all_packing_android.sh $BRANCH $ENV $ForPeople $ChangeLog $NotificatePeople
#sh all_packing_android.sh dev_1.0.0_fix 开发 内测 更新说明略 none
#sh all_packing_android.sh dev_all 测试 内测 更新说明略 none

BRANCH=$1
ENV=$2
ForPeople=$3
ChangeLog=$4
NotificatePeople=$5

if [ $# != 5 ]; then
    echo "当前参数个数$#，必须为5个，请设置更新说明"
    exit 1
fi

CUR_DIR=$PWD    #$PWD代表获取当前路径，当cd后，$PWD也会跟着更新到新的cd路径。这个和在终端操作是一样的道理的
WORKSPACE=$CUR_DIR/..
echo "CUR_DIR=$CUR_DIR"
echo "WORKSPACE=$WORKSPACE"
echo "ChangeLog=$ChangeLog"
if [ -z $ChangeLog ]; then
    echo "请填写更新说明，否则无法打包"
    exit 1
fi

if [ $ENV == "开发" ] ; then
    echo "这个是【开发】包"
    TARGETENVTYPE='develop1'
elif [ $ENV == "测试" ] ; then
    echo "这个是【测试】包"
    TARGETENVTYPE='preproduct'
else
    echo "这个是【生产】包"
    TARGETENVTYPE='product'
fi

echo "ForPeople=$ForPeople"
if [ $ForPeople == "外测" ] ; then
    PackageTargetType="formal"
else
    PackageTargetType="pgyer"
fi

echo "PackageTargetType=$PackageTargetType"
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "NotificatePeople=$NotificatePeople"


cd $WORKSPACE/bulidScript
source ./update_app_info_android.sh $TARGETENVTYPE $PackageTargetType ../wish/android
sh add_extra_app_info.sh $BRANCH $VERSION $BUILD
sh update_app_env.sh $TARGETENVTYPE $PackageTargetType ../wish/lib/main.dart


cd $WORKSPACE/wish
# flutter环境变量设置
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get

#---------------------开始Android打包---------------------

#删除上次的apk
rm -fr "$WORKSPACE/wish/build/app/outputs/apk/release"

#android打包命令
cd $WORKSPACE/wish/android
./gradlew assembleRelease
export LANG=en_US.UTF-8


ipa_file_path="$WORKSPACE/wish/build/app/outputs/apk/release/wish.apk"
#ipa_file_path="$WORKSPACE/bulidScript/dianzan.svg"
if [ ! -f "$ipa_file_path" ];then
    PACKAGESUCCESS="failure:编译打包失败，未生成$ipa_file_path"
    cd $WORKSPACE/bulidScript
    sh noti_new_package.sh $BRANCH Android $TARGETENVTYPE $PackageTargetType $ChangeLog $NotificatePeople $PACKAGESUCCESS
    exit 1
fi


#---------------------开始上传---------------------

#cd $WORKSPACE/wish/
#
#python3 $WORKSPACE/bulidScript/upload_pgyer_apk.py $PYGERKEY
#
#cd $WORKSPACE/bulidScript
#sh noti_new_package.sh $BRANCH Android $TARGETENVTYPE $PackageTargetType $ChangeLog $NotificatePeople $PACKAGESUCCESS
#
#echo 打包完成

cd $WORKSPACE/bulidScript
sh all_packing_upload.sh $BRANCH Android $TARGETENVTYPE $PackageTargetType $ChangeLog $NotificatePeople $VERSION $BUILD $ipa_file_path
if [ $? != 0 ]; then
    exit 1
fi
