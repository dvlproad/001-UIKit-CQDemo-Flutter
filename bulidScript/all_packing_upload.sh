#!/bin/bash
#sh all_packing_upload.sh $BRANCH $PlatformType $TARGETENVTYPE $PackageTargetType $ChangeLog $NotificatePeople $VERSION $BUILD $ipa_file_path
#sh all_packing_upload.sh dev_1.0.0_fix iOS develop1 pgyer 更新说明略 none 1.0.0 7261011 ~/Desktop/dianzan.svg
#sh all_packing_upload.sh dev_all iOS preproduct pgyer 更新说明略 all 1.0.0 7261011 ~/Desktop/dianzan.svg
#sh all_packing_upload.sh dev_will_publish iOS product formal 更新说明略 all 1.0.0 7261011 ~/Desktop/dianzan.svg

cmdself=$0
echo $cmdself        #  ./keep.sh

#截取字符/后面所有字符
cmdfilename=${cmdself#*/}
echo "cmdfilename=${cmdfilename}"

BRANCH=$1
PlatformType=$2
TARGETENVTYPE=$3
PackageTargetType=$4
ChangeLog=$5
NotificatePeople=$6
VERSION=$7
BUILD=$8
ipa_file_path=$9
echo "BRANCH=${BRANCH}"
echo "PlatformType=${PlatformType}"
echo "TARGETENVTYPE=${TARGETENVTYPE}"
echo "PackageTargetType=${PackageTargetType}"
echo "ChangeLog=${ChangeLog}"
echo "NotificatePeople=${NotificatePeople}"
echo "VERSION=${VERSION}"
echo "BUILD=${BUILD}"
echo "ipa_file_path=${ipa_file_path}"


#if [ -z $ChangeLog ]; then
#    ChangeLog = "更新说明略"
#fi


ipa_dir_name=$(dirname "$ipa_file_path")
ipa_file_name_and_extension=$(basename "$ipa_file_path")
ipa_file_extension=${ipa_file_name_and_extension##*.}
echo "包的ipa_dir_name为${ipa_dir_name}"
echo "包的ipa_file_name_and_extension为${ipa_file_name_and_extension}"
echo "包的ipa_file_extension为${ipa_file_extension}"
ipa_file_name_new="${VERSION}($BUILD).${ipa_file_extension}"
ipa_file_path_new="${ipa_dir_name}/${ipa_file_name_new}"
mv ${ipa_file_path} ${ipa_file_path_new}
echo "包的新文件名为${ipa_file_path_new}"
ipa_file_path=${ipa_file_path_new}

if [ $PackageTargetType == "formal" -a $TARGETENVTYPE == 'product' ] ; then
    echo "这是生产外测包。。。。TARGETENVTYPE=$TARGETENVTYPE,PackageTargetType=$PackageTargetType"
#    python ./upload_tf_ipa.py 'wish' '6926S6L669' '6dcf499d-c6e1-4d4f-a431-0574a7d0fdd8'

    if [ $PlatformType == "iOS" ] ; then
        ShoudUploadToAppStrore="yes"
    fi
    
    ShoudUploadToCos="yes"
    ShoudUploadToPgyer="no"
else
    echo "这是非生产外测包。。。。具体为:TARGETENVTYPE=$TARGETENVTYPE,PackageTargetType=$PackageTargetType"
#    python ./upload_pgyer_ipa.py 'wish' $PYGERKEY
    ShoudUploadToAppStrore="no"
    ShoudUploadToCos="no"
    ShoudUploadToPgyer="yes"
fi


if [ $ShoudUploadToPgyer == "yes" ] ; then
    if [ $TARGETENVTYPE == "develop1" -o $TARGETENVTYPE == 'develop2' ] ; then
        PYGERKEY='bb691894f9477b9421b4fe98cccb58fb'
    elif [ $TARGETENVTYPE == "preproduct" ] ; then
        PYGERKEY='a6f5a92ffe5f43677c5580de3e1e0d99'
    elif [ $TARGETENVTYPE == "product" ] ; then
        PYGERKEY='da2bc35c7943aa78e66ee9c94fdd0824'
    else
        UPLOADSUCCESS+="上传蒲公英，环境变量不对，未找到PYGERKEY"
    fi

    echo "正在执行《./s3_uploadapp_pgyer -f $ipa_file_path -k $PYGERKEY -e $TARGETENVTYPE -b $BRANCH -t no -d $ChangeLog》..."
    ./s3_uploadapp_pgyer -f $ipa_file_path -k $PYGERKEY -e $TARGETENVTYPE -b $BRANCH -t no -d $ChangeLog
    if [ $? != 0 ]; then
        UPLOADSUCCESS+="上传到蒲公英的脚本执行失败.............."
    fi
fi

if [ $ShoudUploadToCos == "yes" ] ; then
    echo "正在执行《./sh upload_cos.sh $ipa_file_path》..."
    source ./upload_cos.sh $ipa_file_path
    if [ $? != 0 ]; then
        UPLOADSUCCESS+="上传到腾讯云cos的脚本执行失败.............."
    fi
    echo "Cos_Network_File_Url=$Cos_Network_File_Url"
fi

echo "ShoudUploadToAppStrore=${ShoudUploadToAppStrore}"
if [ $ShoudUploadToAppStrore == "yes" ] ; then
    echo "正在执行《iTMSTransporter -m upload -assetFile $ipa_file_path -u 'chenmingxi@xihuanwu.com' -p 'djjj-bjkz-rghr-aish'》..."
    /Applications/Xcode.app/Contents/SharedFrameworks/ContentDeliveryServices.framework/itms/bin/iTMSTransporter -m upload -assetFile $ipa_file_path -u "chenmingxi@xihuanwu.com" -p "djjj-bjkz-rghr-aish"
    if [ $? != 0 ]; then
        UPLOADSUCCESS+="上传到AppStore的脚本执行失败.............."
    fi
fi


if [ -z "$UPLOADSUCCESS" ]; then
    UPLOADSUCCESS="success"
fi


echo "UPLOADSUCCESS=$UPLOADSUCCESS"
echo "Cos_Network_File_Url=$Cos_Network_File_Url"
sh noti_new_package.sh $BRANCH $PlatformType $TARGETENVTYPE $PackageTargetType $ChangeLog $NotificatePeople $UPLOADSUCCESS $Cos_Network_File_Url
if [ $UPLOADSUCCESS != "success" ] ; then
    exit 1
else
    echo 上传完成
fi




