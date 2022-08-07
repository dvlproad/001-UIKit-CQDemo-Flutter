import 'package:package_info/package_info.dart';

String _version = '';

class DeviceInfo {
  static Future<String> version() async {
    if (_version == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
    }

    return _version;
  }
}
