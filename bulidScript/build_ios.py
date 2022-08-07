# -*- coding: UTF-8 -*-
#
# Build and upload to fir to test and review.
#
import os
import sys
import plistlib
 
WORKSPACENAME = sys.argv[1]
SCHEME = sys.argv[2]
CONFIGURATION = sys.argv[3]
SDK = sys.argv[4]
EnvType = sys.argv[5]
PackageTargetType = sys.argv[6]
 
class iOSBuilder(object):
    def udpate_pod(self):
        podfile = os.path.join(os.getcwd(), 'Podfile')
        podfile_lock = os.path.join(os.getcwd(), 'Podfile.lock')
        if os.path.isfile(podfile) or os.path.isfile(podfile_lock):
            print("Update pod dependencies =============")
            cmd_shell = 'pod repo update'
            os.system(cmd_shell)
            print("Install pod dependencies =============")
            cmd_shell = 'pod install'
            os.system(cmd_shell)
 
    def build_Archive(self):
        archive_path = os.path.join(os.getcwd(), "outputs", SCHEME + ".xcarchive")
        cmdbuild = 'xcodebuild ' \
                   ' -workspace ' + WORKSPACENAME + ".xcworkspace" \
                   ' -configuration ' + CONFIGURATION + \
                   ' -scheme ' + SCHEME + \
                   ' -sdk ' + SDK + \
                   ' archive -archivePath ' + archive_path + \
                   ' -allowProvisioningUpdates ' + \
                   ' -allowProvisioningDeviceRegistration '
        print("build archive ============= {}".format(cmdbuild))
        # Execute the build command
        os.system(cmdbuild)
        return archive_path
 
    def export_ipa(self):
        export_path = os.path.join(os.getcwd(), "outputs", "IPA")
        archive_path = os.path.join(os.getcwd(), "outputs", SCHEME + ".xcarchive")
        #debugVersionProvisioningProfileName = "\"iOS Team Provisioning Profile: com.laifenqi.fenqiapp\""
        #plistfile = os.path.join(os.getcwd(), "Scripts", 'exportOptions.plist')
        temp_path = os.path.abspath(os.path.dirname(os.getcwd()))
        print("temp_path=========" + temp_path)
        if EnvType == "develop1" or EnvType == "develop2" :
            exportOptionsPlistFileName = 'exportOptions_dev.plist'
        elif EnvType == "preproduct":
            exportOptionsPlistFileName = 'exportOptions_dev.plist'
        elif EnvType == "product":
            if PackageTargetType == "formal":
                exportOptionsPlistFileName = 'exportOptions_tf.plist'
            else:
                exportOptionsPlistFileName = 'exportOptions_dev.plist'
        plistfile = os.path.join(temp_path, "../bulidScript/ios_exportOptions", exportOptionsPlistFileName)
        print("plistfile=========" + plistfile)
        if not os.path.exists(plistfile):
            raise "exportOptions.plist文件不能为空！"
        cmdExport = 'xcodebuild -exportArchive ' \
                    ' -archivePath ' + archive_path + \
                    ' -exportOptionsPlist ' + plistfile + \
                    ' -exportPath ' + export_path + \
                    ' -allowProvisioningUpdates'
        # Code Sign
        #' PROVISIONING_PROFILE_SPECIFIER= '  + debugVersionProvisioningProfileName;
        print("build export ============= {}".format(cmdExport))
        os.system(cmdExport)
        return export_path
 
    def build_clean(self):
        os.system("xcodebuild clean -alltargets")
        os.system("rm -fr outputs")
        os.system("rm -fr Pods/build")
        return
 
    def unlock_keychain(self):
        os.system("security unlock-keychain -p 20160711 /Users/Layne/Library/Keychains/Login.keychain")
        return
 
    def change_build_version(self):
        build_version_list = self._build_version.split('.')
        cf_bundle_short_version_string = '.'.join(build_version_list[:3])
        with open(self._plist_path, 'rb') as fp:
            plist_content = plistlib.load(fp)
            plist_content['CFBundleShortVersionString'] = cf_bundle_short_version_string
            plist_content['CFBundleVersion'] = self._build_version
        with open(self._plist_path, 'wb') as fp:
            plistlib.dump(plist_content, fp)
 
def main():
    ios_builder = iOSBuilder()
    #
    ios_builder.udpate_pod()
    #
    ios_builder.unlock_keychain()
    #
    ios_builder.build_clean()
    #
    ios_builder.build_Archive()
    #
    ios_builder.export_ipa()
 
 
if __name__ == '__main__':
    main()
