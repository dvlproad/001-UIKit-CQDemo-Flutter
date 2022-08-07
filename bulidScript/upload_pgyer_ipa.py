# -*- coding: UTF-8 -*-
#
# Build and upload to fir to test and review.
#
import os
import sys
import plistlib

IPA_NAME = sys.argv[1]
PGY_KEY = sys.argv[2]
 
class iOSBuilder(object):
    def uploadToFir(self):
        ipa_path = os.path.join(os.getcwd(), "outputs/IPA", IPA_NAME +  ".ipa")
        if not os.path.exists(ipa_path):
            raise "安装包不存在!"
#        cmdFirUpload = "fir publish " + ipa_path + " -T fb180a89a6efa6b3bc1eedddf67b261b"
#        print("### FIR Upload ###, Command - " + cmdFirUpload)
        os.system("curl -F 'file=@%s' -F '_api_key=%s' -F'updateDescription=%s' https://www.pgyer.com/apiv2/app/upload"%(ipa_path,PGY_KEY,'默认文案'))
        #os.system(cmdPygUpload)
        return ipa_path
 
def main():
    ios_builder = iOSBuilder()

    ios_builder.uploadToFir()
 
 
if __name__ == '__main__':
    main()
