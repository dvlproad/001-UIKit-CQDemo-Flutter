class PrintConsoleLogUtil {
  static const String _TAG_DEFAULT = "###qianqianqian###\n";
  static void printConsoleLog(String tag, String stag, Object object) {
    if (object is String) {
      print(object);
      return;
    }

    StringBuffer sb = StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? _TAG_DEFAULT : tag);
    sb.write('\n');
    sb.write(stag);
    sb.write('\n');
    sb.write(object);
    print(sb.toString());
  }
}
