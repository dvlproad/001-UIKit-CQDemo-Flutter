#!/bin/bash
# sh upload_cos.sh ~/Desktop/dianzan.svg

# 命令：
# ~/Library/Python/3.8/bin/coscmd -b prod-xhw-image-1302324914 -r ap-shanghai upload -r ~/Desktop/dianzan.svg /mcms/download/app/
# 结果：
# https://console.cloud.tencent.com/cos/bucket?bucket=prod-xhw-image-1302324914&region=ap-shanghai&path=%252Fmcms%252Fdownload%252Fapp%252F
# https://images.xihuanwu.com/mcms/download/app/

exit_script() { # 退出脚本的方法，省去当某个步骤失败后，还去继续多余的执行其他操作
    exit 1
}

UPLOAD_FILE_PATH=$1           # 要上传的文件的本地绝对路径
UPLOAD_FILE_Name=$(basename "$UPLOAD_FILE_PATH")
echo "UPLOAD_FILE_PATH=$UPLOAD_FILE_PATH"
echo "UPLOAD_FILE_Name=$UPLOAD_FILE_Name"

BUCKET=prod-xhw-image-1302324914
REGION=ap-shanghai
COS_PATH=/mcms/download/app/
coscmd -b ${BUCKET} -r ${REGION} upload -r ${UPLOAD_FILE_PATH} ${COS_PATH}
if [ $? = 0 ]   # 上个命令的退出状态，或函数的返回值。
then
	Cos_Network_File_Url="https://images.xihuanwu.com/mcms/download/app/${UPLOAD_FILE_Name}"
    echo "-------- Success：${UPLOAD_FILE_PATH} 文件上传cos成功，路径为${Cos_Network_File_Url} --------"
else
    Cos_Network_File_Url="上传失败，无地址"
    echo "-------- Failure：${UPLOAD_FILE_PATH} 文件上传cos失败，不继续操作 --------"
    exit_script
fi
