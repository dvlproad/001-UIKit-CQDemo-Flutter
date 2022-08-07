#!/bin/bash
#sh update_app_info_android.sh $TARGETENVTYPE $PackageTargetType $FlutterAndroidProjectHOME
#sh update_app_info_android.sh develop1 pgyer ../wish/android

TARGETENVTYPE=$1
PackageTargetType=$2
FlutterAndroidProjectHOME=$3
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "PackageTargetType=$PackageTargetType"

if [ $PackageTargetType == "pgyer" ] ; then
    VERSION="1."$(date "+%m.%d") # 1.02.21
else
    VERSION="1.0.1"
fi
BUILD=$(date "+%m%d%H%M") # 02211506
BUILD=$(echo $BUILD | sed -r 's/0*([0-9])/\1/') # 去除字符串前所有的0
echo "------VERSION:${VERSION}"
echo "------BUILD:${BUILD}"


if [ $TARGETENVTYPE == "develop1" ] ; then
    APPNAME="愿望屋开发版"
elif [ $TARGETENVTYPE == "develop2" ] ; then
    APPNAME="愿望屋开发版"
elif [ $TARGETENVTYPE == "preproduct" ] ; then
    APPNAME="愿望屋测试版"
else
    APPNAME="愿望屋"
fi

AndroidProjectPbxprojPath=$FlutterAndroidProjectHOME/app/build.gradle
#替换Version
sed -i '' "s/flutterVersionName = '1.0.0'/flutterVersionName = '${VERSION}'/g" $AndroidProjectPbxprojPath

#替换Build号
sed -i '' "s/flutterVersionCode = 1/flutterVersionCode = ${BUILD}/g" $AndroidProjectPbxprojPath

#修改app名
iOSInfoPlistPath=$FlutterAndroidProjectHOME/app/src/main/AndroidManifest.xml
sed -i '' "s/愿望屋/${APPNAME}/g" $iOSInfoPlistPath
