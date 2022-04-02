#sh build_android.sh dev_1.0.0_fix 开发
#sh build_android.sh dev_all 测试

BRANCH=$1
ENV=$2

CUR_DIR=$PWD    #$PWD代表获取当前路径，当cd后，$PWD也会跟着更新到新的cd路径。这个和在终端操作是一样的道理的
WORKSPACE=$CUR_DIR/..
echo "CUR_DIR=$CUR_DIR"
echo "WORKSPACE=$WORKSPACE"

if [ $ENV == "开发" ] ; then
    echo "这个是【开发】包"
     TARGETENVTYPE='develop1'
    PYGERKEY='a6f5a92ffe5f43677c5580de3e1e0d99'
    
elif [ $ENV == "测试" ] ; then
    echo "这个是【测试】包"
    TARGETENVTYPE='preproduct'
    PYGERKEY='bb691894f9477b9421b4fe98cccb58fb'
else
    echo "这个是【生产】包"
    TARGETENVTYPE='product'
    PYGERKEY='da2bc35c7943aa78e66ee9c94fdd0824'
fi

cd $WORKSPACE/bulidScript
sh add_extra_app_info.sh $BRANCH
sh update_app_env.sh $TARGETENVTYPE ../wish/lib/main.dart



cd $WORKSPACE/wish
# flutter环境变量设置
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
flutter pub get

#---------------------开始Android打包---------------------

cd $WORKSPACE/wish/android

#android打包命令
./gradlew assembleRelease
export LANG=en_US.UTF-8


#---------------------开始上传---------------------

cd $WORKSPACE/wish/

python $WORKSPACE/bulidScript/build_upload_apk.py $PYGERKEY


cd $WORKSPACE/bulidScript
sh noti_new_package.sh Android $BRANCH $TARGETENVTYPE 更新说明略

echo 打包完成