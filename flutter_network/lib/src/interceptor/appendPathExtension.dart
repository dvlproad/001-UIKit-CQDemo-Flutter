// 拼接路径字符串
extension PathStringAppendExtension on String {
  String appendPathString(String appendPath) {
    String noslashThis; // 没带斜杠的 api host
    if (this.endsWith('/')) {
      noslashThis = this.substring(0, this.length - 1);
    } else {
      noslashThis = this;
    }

    String hasslashAppendPath; // 带有斜杠的 appendPath
    if (appendPath.startsWith('/')) {
      hasslashAppendPath = appendPath;
    } else {
      hasslashAppendPath = '/' + appendPath;
    }

    String newPath = noslashThis + hasslashAppendPath;
    return newPath;
  }
}
