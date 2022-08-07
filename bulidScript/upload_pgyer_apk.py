# -*- coding: UTF-8 -*-
#
# Build and upload to fir to test and review.
#
import os
import sys
import plistlib

PGY_KEY = sys.argv[1] 
 
class iOSBuilder(object):
 
    def uploadToFir(self):
        apk_path = ""
        file_dir = os.path.join(os.getcwd(), "build/app/outputs/apk/release")
        print("file_dir = " + file_dir)
        for root, dirs, files in os.walk(file_dir):  
            print(root) #当前目录路径  
            print(dirs) #当前路径下所有子目录  
            print(files) #当前路径下所有非目录子文件  
            for file in files:
                if file.endswith('.apk'):
                    apk_path = file_dir + '/' + file
        
        print('apk_path = ' + apk_path)

        if not os.path.exists(apk_path):
            raise "安装包不存在!"
        os.system("curl -F 'file=@%s' -F '_api_key=%s' -F'updateDescription=%s' https://www.pgyer.com/apiv2/app/upload"%(apk_path,PGY_KEY,'默认文案'))
        #os.system(cmdPygUpload)
        return apk_path
 
    def build_clean(self):
        file_dir = os.path.join(os.getcwd(), "build/app/outputs/apk/release")
        os.system("rm -fr " + file_dir)
        return
 
def main():
    ios_builder = iOSBuilder()
    #
    ios_builder.uploadToFir()
    #
    # ios_builder.build_clean()
 
 
if __name__ == '__main__':
    main()