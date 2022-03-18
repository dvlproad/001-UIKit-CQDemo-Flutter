#sh update_app_info_ios.sh $TARGETENVTYPE ../wish/ios

TARGETENVTYPE=$1
FlutterIOSProjectHOME=$2
echo "TARGETENVTYPE=$TARGETENVTYPE"

VERSION="1."$(date "+%m.%d") # 1.02.21
BUILD=$(date "+%H%M") # 1506
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
