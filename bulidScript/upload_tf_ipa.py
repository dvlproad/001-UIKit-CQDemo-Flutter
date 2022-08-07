# -*- coding: UTF-8 -*-
#
# Build and upload to fir to test and review.
#
import os
import sys
import plistlib

IPA_NAME = sys.argv[1]
API_KEY = sys.argv[2]
API_ISSUER_KEY = sys.argv[3]

 
class iOSBuilder(object):
    def uploadToFir(self):
        ipa_path = os.path.join(os.getcwd(), "outputs/IPA", IPA_NAME +  ".ipa")
        if not os.path.exists(ipa_path):
            raise "安装包不存在!"
        
        os.system("xcrun altool --upload-app -f %s -t iOS --apiKey %s --apiIssuer %s"%{ipa_path, API_KEY, API_ISSUER_KEY})
        # os.system("curl -F 'file=@%s' -F '_api_key=%s' -F'updateDescription=%s' https://www.pgyer.com/apiv2/app/upload"%(ipa_path,PGY_KEY,'默认文案'))
        return ipa_path
 
def main():
    ios_builder = iOSBuilder()

    ios_builder.uploadToFir()
 
 
if __name__ == '__main__':
    main()
