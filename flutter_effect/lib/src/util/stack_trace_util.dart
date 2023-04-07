// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-05-12 19:40:05
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 14:13:26
 * @Description: 堆栈信息获取工具
 */
import 'package:stack_trace/stack_trace.dart';

printStack() {
  print('$__CLASS__ $__METHOD__($__FILE__:$__LINE__)');
}

String? get __CLASS__ {
  var frames = Trace.current().frames; //调用栈
  if (frames.length > 1) {
    var member = frames[1].member;
    var parts = member?.split(".");
    if (parts != null && parts.length > 1) {
      return parts[0];
    }
  }

  return null;
}

String? get __METHOD__ {
  var frames = Trace.current().frames;
  if (frames.length > 1) {
    var member = frames[1].member;
    var parts = member?.split(".");
    if (parts != null && parts.length > 1) {
      return parts[1];
    }
  }

  return null;
}

String? get __FILE__ {
  var frames = Trace.current().frames;
  if (frames.length > 1) {
    return frames[1].uri.path;
  }

  return null;
}

int? get __LINE__ {
  var frames = Trace.current().frames;
  if (frames.length > 1) {
    return frames[1].line;
  }

  return null;
}
