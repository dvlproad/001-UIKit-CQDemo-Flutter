#!/bin/bash
#sh update_app_info_ios.sh $TARGETENVTYPE $PackageTargetType $FlutterIOSProjectHOME
#sh update_app_info_ios.sh develop1 pgyer ../wish/ios

TARGETENVTYPE=$1
PackageTargetType=$2
FlutterIOSProjectHOME=$3
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "PackageTargetType=$PackageTargetType"

if [ $PackageTargetType == "pgyer" ] ; then
    VERSION="1."$(date "+%m.%d") # 1.02.21
else
    VERSION="1.0.0"
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

iOSProjectPbxprojPath=$FlutterIOSProjectHOME/Runner.xcodeproj/project.pbxproj
#替换Version
sed -i '' "s/MARKETING_VERSION = 1.0.0/MARKETING_VERSION = ${VERSION}/g" $iOSProjectPbxprojPath

#替换Build号
sed -i '' "s/CURRENT_PROJECT_VERSION = 1/CURRENT_PROJECT_VERSION = ${BUILD}/g" $iOSProjectPbxprojPath

#修改app名
iOSInfoPlistPath=$FlutterIOSProjectHOME/Runner/Info.plist
sed -i '' "s/愿望屋/${APPNAME}/g" $iOSInfoPlistPath
