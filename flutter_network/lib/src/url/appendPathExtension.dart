/*
 * @Author: dvlproad
 * @Date: 2023-01-30 11:55:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 16:57:44
 * @Description: 拼接路径字符串
 */
extension PathStringAppendExtension on String {
  String appendPathString(String appendPath) {
    String noslashThis; // 没带斜杠的 api host
    if (endsWith('/')) {
      noslashThis = substring(0, length - 1);
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
