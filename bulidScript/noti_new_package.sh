#sh noti_new_package.sh $PlatformType $BRANCH $TARGETENVTYPE $NotificationText
#sh noti_new_package.sh iOS dev_all develop1 优化用户体验

PlatformType=$1
BRANCH=$2
TARGETENVTYPE=$3
CHANGELOG=$4
#NewPackageVersion=
echo "TARGETENVTYPE=$TARGETENVTYPE"
echo "CHANGELOG=$CHANGELOG"


exit_script() { # 退出脚本的方法，省去当某个步骤失败后，还去继续多余的执行其他操作
    exit 1
}


# 单个人测试用的
myRobotUrl='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'

# 新包提醒
newPackageRobotUrl='https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=2a1672b4-fbb5-4b60-8ba2-4a37e053e05a'




#! /bin/bash
JQ_EXEC=`which jq`
FILE_PATH=app_info.json

packageVersion=$(cat $FILE_PATH | ${JQ_EXEC} .version | sed 's/\"//g')
packageCreateTime=$(cat $FILE_PATH | ${JQ_EXEC} .package_create_time | sed 's/\"//g')
echo "packageVersion=$packageVersion,packageCreateTime=$packageCreateTime"


declare -a MentionedList

if [ $TARGETENVTYPE == "develop1" ] ; then
    NewPackageVersionDes='开发包'
    ROBOTURL=$newPackageRobotUrl
    appDownloadUrl='https://www.pgyer.com/kKTt'
elif [ $TARGETENVTYPE == "develop2" ] ; then
    NewPackageVersionDes='开发包'
    ROBOTURL=$newPackageRobotUrl
    appDownloadUrl='https://www.pgyer.com/kKTt'
elif [ $TARGETENVTYPE == "preproduct" ] ; then
    NewPackageVersionDes='测试包'
    ROBOTURL=$newPackageRobotUrl
    appDownloadUrl='https://www.pgyer.com/Jzqc'
    MentionedList[0]="@all"
else
    NewPackageVersionDes='生产包'
    ROBOTURL=$newPackageRobotUrl
    appDownloadUrl='https://www.pgyer.com/app_bj'
    MentionedList[0]="@all"
fi
echo "MentionedList=${MentionedList}"

NewPackageVersionDes="${NewPackageVersionDes}_${PlatformType}V${packageVersion}(${packageCreateTime})"

LastNotificationText="恭喜💐：${BRANCH}\n${NewPackageVersionDes}打包成功。\n下载地址：${appDownloadUrl}。\n更新内容如下：\n${CHANGELOG}"
LastNotificationText+="\n\n赶紧下载来看看有没有自己的问题吧🏃🏻‍♀️🏃🏻‍♀️🏃🏻‍♀️"
echo "LastNotificationText=$LastNotificationText"


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

