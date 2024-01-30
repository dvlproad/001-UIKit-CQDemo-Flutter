/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad dvlproad@163.com
 * @LastEditTime: 2023-03-23 21:52:59
 * @Description: 旧的类扩展转字符串方法（如果不是Object，而是自定义类的话，要转sting，请自己重写 toString() 方法即可）
 */

class LogStringUtil {
  static String stringFromMap(Map map, {int indentation = 2}) {
    return map.mapToStructureString();
  }

  static String stringFromList(List list, {int indentation = 2}) {
    return list.listToStructureString();
  }
}

///Map拓展，MAp转字符串输出
extension Map2StringExtension on Map {
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "{";
      forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr"
              "\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          if (value is int || value is double) {
            result += "\n$indentationStr" "\"$key\" : $value,";
          } else if (value is String) {
            result += "\n$indentationStr" "\"$key\" : \"$value\",";
          } else {
            result += "\n$indentationStr" "\"$key\" : \"$value\",";
          }
        }
      });
      result = result.substring(0, result.length - 1);
      result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";
    }

    return result;
  }
}

///List拓展，List转字符串输出
extension List2StringExtension on List {
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "$indentationStr[";
      for (var value in this) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" "\"$temp\",";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else if (value is int) {
          result += "\n$indentationStr" "$value,";
        } else {
          result += "\n$indentationStr" "\"$value\",";
        }
      }
      result = result.substring(0, result.length - 1);
      result += "\n$indentationStr]";
    }

    return result;
  }
}
