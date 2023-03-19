/*
 * @Author: dvlproad
 * @Date: 2022-06-01 16:12:12
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-06-08 14:41:19
 * @Description: 
 */

/// 子元素开始曝光回调，返回子元素开始曝光的信息
typedef ExposureStartCallback = void Function(ExposureStartIndex index);

/// 子元素结束曝光回调，返回子元素结束曝光的信息
typedef ExposureEndCallback = void Function(ExposureEndIndex index);

/// 根据当前子节点元素的状态判断此子节点是否处于曝光状态
/// [index]子节点位置信息，[paintExtent]子节点在屏幕中可见的范围
/// [maxPaintExtent]子节点完全展示时的范围，如果将子节点完全
/// 展示作为曝光的依据可返回 [paintExtent == maxPaintExtent]
typedef ExposureReferee = bool Function(
    ExposureStartIndex index, double paintExtent, double maxPaintExtent);

class IndexRange {
  // 父节点下标
  final int parentIndex;

  // 第一个可见的元素下标
  final int firstIndex;

  // 最后一个可见元素下标
  final int lastIndex;

  IndexRange({
    required this.parentIndex,
    required this.firstIndex,
    required this.lastIndex,
  });

  IndexRange.parentIndex(this.parentIndex, IndexRange other)
      : this.firstIndex = other.firstIndex,
        this.lastIndex = other.lastIndex;
}

class ExposureStartIndex {
  // 父节点下标
  final int parentIndex;

  // 曝光子节点下标
  final int? itemIndex;

  // 曝光开始时间
  final int startExposureTimeStamp;

  ExposureStartIndex({
    required this.parentIndex,
    required this.itemIndex,
    required this.startExposureTimeStamp,
  });

  String get message {
    DateTime startDateTime =
        DateTime.fromMillisecondsSinceEpoch(startExposureTimeStamp);
    String startDateTimeString = startDateTime.toString().substring(5, 19);

    String indexString = this.itemIndex.toString().padLeft(2, '0');
    // return 'parentIndex=${this.parentIndex},\n下标:${indexString},曝光开始于:${startDateTimeString}';
    return 'parentIndex=${this.parentIndex},下标:${indexString},曝光开始于:${startDateTimeString}';
  }
}

class ExposureEndIndex {
  // 父节点下标
  final int parentIndex;

  // 曝光子节点下标
  final int? itemIndex;

  // 曝光开始时间
  final int startExposureTimeStamp;

  // 曝光结束时间
  final int endExposureTimeStamp;

  ExposureEndIndex({
    required this.parentIndex,
    required this.itemIndex,
    required this.startExposureTimeStamp,
    required this.endExposureTimeStamp,
  });

  // 曝光时长
  int get exposureDuration {
    return endExposureTimeStamp - startExposureTimeStamp;
  }

  String get message {
    DateTime startDateTime =
        DateTime.fromMillisecondsSinceEpoch(startExposureTimeStamp);
    String startDateTimeString = startDateTime.toString().substring(5, 19);

    DateTime endDateTime =
        DateTime.fromMillisecondsSinceEpoch(endExposureTimeStamp);
    String endDateTimeString = endDateTime.toString().substring(5, 19);

    double seconds = exposureDuration.toDouble() / 1000.0;

    String indexString = this.itemIndex.toString().padLeft(2, '0');

    return 'parentIndex=${this.parentIndex}下标:${indexString},曝光时长:${seconds}s,曝光开始于:${startDateTimeString},曝光结束于:${endDateTimeString}.';
    // return 'parentIndex=${this.parentIndex}\n下标:${indexString},曝光时长:${seconds}s\n曝光开始于:${startDateTimeString},\n曝光结束于:${endDateTimeString}.';
  }
}
