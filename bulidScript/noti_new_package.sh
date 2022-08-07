#!/bin/bash
#sh noti_new_package.sh $BRANCH $PlatformType $TARGETENVTYPE $PackageTargetType $CHANGELOG $NotificatePeople $PACKAGESUCCESS $Package_Network_File_Url
#sh noti_new_package.sh dev_all iOS develop1 pgyer 优化用户体验 all success https://a/b/123.txt

BRANCH=$1
PlatformType=$2
TARGETENVTYPE=$3
PackageTargetType=$4
CHANGELOG=$5
NotificatePeople=$6
PACKAGESUCCESS=$7
Package_Network_File_Url=$8
echo "BRANCH=$BRANCH"
echo "PlatformType=$PlatformType"
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "PackageTargetType=$PackageTargetType"
echo "CHANGELOG=$CHANGELOG"
echo "NotificatePeople=$NotificatePeople"
echo "PACKAGESUCCESS=$PACKAGESUCCESS"
echo "Package_Network_File_Url=$Package_Network_File_Url"


if [ $NotificatePeople == "none" ] ; then
    exit
fi


exit_script() { # 退出脚本的方法，省去当某个步骤失败后，还去继续多余的执行其他操作
    exit 1
}


# 单个人测试用的
myRobotUrl='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'

# 新包提醒
newPackageRobotUrl='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=2a1672b4-fbb5-4b60-8ba2-4a37e053e05a'
#newPackageRobotUrl=$myRobotUrl



#! /bin/bash
JQ_EXEC=`which jq`
FILE_PATH="app_info.json"

packageVersion=$(cat $FILE_PATH | ${JQ_EXEC} .version | sed 's/\"//g')
packageBuildNumber=$(cat $FILE_PATH | ${JQ_EXEC} .buildNumber | sed 's/\"//g')
packageCreateTime=$(cat $FILE_PATH | ${JQ_EXEC} .package_create_time | sed 's/\"//g')
echo "packageVersion=$packageVersion,packageBuildNumber=$packageBuildNumber,packageCreateTime=$packageCreateTime"
if [ ! -n "$packageVersion" ]; then
    echo "❌Error:app_info.json解析失败,文件中的内容格式出错，不是标准json"
fi



#[shell数组](https://www.runoob.com/linux/linux-shell-array.html)
declare -a MentionedList

if [ $TARGETENVTYPE == "develop1" ] ; then
    NewPackageVersionDes='开发包'
    ROBOTURL=$newPackageRobotUrl
    appOfficialWebsite='https://www.pgyer.com/Jzqc'
    NotificationEmoji=""
elif [ $TARGETENVTYPE == "develop2" ] ; then
    NewPackageVersionDes='开发包'
    ROBOTURL=$newPackageRobotUrl
    appOfficialWebsite='https://www.pgyer.com/Jzqc'
    NotificationEmoji=""
elif [ $TARGETENVTYPE == "preproduct" ] ; then
    NewPackageVersionDes='测试包'
    ROBOTURL=$newPackageRobotUrl
    appOfficialWebsite='https://www.pgyer.com/bjtkewish'
    MentionedList[0]="@all"
    NotificationEmoji=""
else
    NewPackageVersionDes='生产包'
    ROBOTURL=$newPackageRobotUrl
    
    if [ $PackageTargetType == "formal" -a $PlatformType == 'iOS' ] ; then
        echo "这是生产外测包iOS。。。。TARGETENVTYPE=$TARGETENVTYPE,PackageTargetType=$PackageTargetType"
        appUploadContinue="1.后续操作：\n\
        请确认包是否已自动上传到苹果TestFlight后台，若失败，请下载cos地址手动上传，若成功则\n\
        ①请从电脑登录https://appstoreconnect.apple.com，进入'我的app'->XXX应用->顶部'TestFlight'->左侧'构建版本'\n\
        ②操作想要发布的版本，\n\
        ③请版本检查更新人员更新最新的版本号、构件号、下载地址三要素"
        appUploadCheck="2.发布后检查(新版本下载方法也是如此):\n\
        ①请在iPhone上通过浏览器打开https://testflight.apple.com/join/TRKtWdEe，进入后跳到TestFlight即可看到应用\n\
        ②打开旧版app，查看是否弹出后台指定的新版本更新提示\n\
        ③官网下载也顺便看下"
        appOfficialWebsite='http://h5.yuanwangwu.com/pages-h5/share/download-app'
        NotificationEmoji="😄😄😄😄😄😄😄😄😄😄\n"
    elif [ $PackageTargetType == "formal" -a $PlatformType == 'Android' ] ; then
        echo "这是生产外测包Android。。。。TARGETENVTYPE=$TARGETENVTYPE,PackageTargetType=$PackageTargetType"
        appOfficialWebsite='http://h5.yuanwangwu.com/pages-h5/share/download-app'
        appUploadContinue="1.后续操作：\n\
        ①请点击cos链接确保包是否已正确上传到cos;\n\
        ②请版本检查更新人员更新最新的版本号、构件号、下载地址三要素"
        appUploadCheck="2.发布后检查(新版本下载方法也是如此):\n\
        ①打开旧版app，查看是否弹出后台指定的新版本更新提示\n\
        ②官网下载也顺便看下"
        NotificationEmoji="😄😄😄😄😄😄😄😄😄😄\n"
    else
        echo "这是生产内测包。。。。TARGETENVTYPE=$TARGETENVTYPE,PackageTargetType=$PackageTargetType"
        if [ $PlatformType == 'iOS' ] ; then
            appOfficialWebsite='https://www.pgyer.com/app_bj'
        fi
        if [ $PlatformType == 'Android' ] ; then
            appOfficialWebsite='https://www.pgyer.com/bjprowishA'
        fi
        NotificationEmoji="💐💐💐💐💐💐💐💐💐💐\n"
    fi
    
    MentionedList[0]="@all"
    
fi
echo "MentionedList=${MentionedList}"

NewPackageVersionDes="${PackageTargetType}_${NewPackageVersionDes}_${PlatformType}V${packageVersion}(${packageBuildNumber})"


LastNotificationText+=${NotificationEmoji}
if [ $PACKAGESUCCESS == "success" ] ; then
    LastNotificationText+="恭喜✅：${BRANCH}\n${NewPackageVersionDes}成功。"
    if [ -n "$Package_Network_File_Url" ]; then
        LastNotificationText+="\ncos地址：${Package_Network_File_Url}"
    fi
    if [ -n "$appUploadContinue" ]; then
        LastNotificationText+="\n${appUploadContinue}。"
    fi
    if [ -n "$appUploadCheck" ]; then
        LastNotificationText+="\n${appUploadCheck}。"
    fi
    LastNotificationText+="\n官网：${appOfficialWebsite}。"
    if [ -n "$CHANGELOG" ]; then
        LastNotificationText+="\n更新内容：\n${CHANGELOG}"
    fi
    LastNotificationText+="\n\n赶紧下载来看看有没有自己的问题吧🏃🏻‍♀️🏃🏻‍♀️🏃🏻‍♀️"
else
    if [ $PACKAGESUCCESS == "上传到AppStore的脚本执行失败.............." ] ; then
        LastNotificationText+="就差一步了💪🏻：${BRANCH}\n${NewPackageVersionDes}。"
    else
        LastNotificationText+="很抱歉❌：${BRANCH}\n${NewPackageVersionDes}失败。"
    fi
    
    LastNotificationText+="\n原因：${PACKAGESUCCESS}"
    if [ -n "$Package_Network_File_Url" ]; then
        LastNotificationText+="\ncos地址：${Package_Network_File_Url}"
    fi
    LastNotificationText+="\n找上个版本可去官网：${appOfficialWebsite}"
#    MentionedList[0]="lichaoqian"
#    MentionedList[1]="linzehua"
    MentionedList=("lichaoqian" "linzehua" "hehua" "hongjiaxing")
fi
echo "LastNotificationText=${LastNotificationText}"


#responseResult=$(\
#curl $ROBOTURL \
#   -H 'Content-Type: application/json' \
#   -d '
#   {
#        "msgtype": "text",
#        "text": {
#            "content": "hello world",
#            "mentioned_list":["wangqing","@all"],
#        }
#   }'
#)

responseResult=$(\
curl $ROBOTURL \
   -H "Content-Type: application/json" \
   -d "{
        \"msgtype\": \"text\",
        \"text\": {
            \"content\": \"${LastNotificationText}\",
            \"mentioned_list\":\"${MentionedList}\"
             }
       }"
)


#[Shell 中curl请求变量参数](https://www.jianshu.com/p/102bd1c48e02)
#curl-X POST --header'Content-Type: application/json'
#--header'Accept: application/json'
#--header'authtype: local'
#--header"username: $admin_user"
#--header"password:${admin_token}"
#-d"{\"email\": \"$payment_email\", \"paymentAccount\": \"$payment_account\", \"paymentServer\": \"${server_name}\", \"remarks\": \"vendor for${wx_service_name}\", \"vendor\": \"xxx\" }" "http://xxxxx.com/api/001api"-w"\nhttp_code=%{http_code}\n"-v -o${result_log} |grep'http_code=200'


if [ $? = 0 ]   # 上个命令的退出状态，或函数的返回值。
then
#    echo "responseResult=$responseResult"
    responseResultCode=$(echo ${responseResult} | jq  '.errcode') # mac上安装brew后，执行brew install jq安装jq
    #echo "responseResultCode=${responseResultCode}"
    if [ $responseResultCode = 0 ];then
        echo "-------- 脚本${0} Success: 新版本通知成功，继续操作 --------"
    else
        responseErrorMessage=$(echo ${responseResult} | jq  '.errmsg')
#        echo "responseErrorMessage=${responseErrorMessage}"
        echo "-------- 脚本${0} Failure: 新版本通知失败responseErrorMessage=${responseErrorMessage}，不继续操作 --------"
        exit_script
    fi
    
else
    echo "-------- 脚本${0} Failure: 新版本通知失败responseResultCode=${responseResultCode}，不继续操作 --------"
    exit_script
fi

