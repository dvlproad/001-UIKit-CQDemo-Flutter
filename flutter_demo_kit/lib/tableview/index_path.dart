/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad dvlproad@163.com
 * @LastEditTime: 2023-03-24 00:22:16
 * @Description: 
 */
class IndexPath {
  final int section;
  final int row;

  IndexPath({
    required this.section,
    required this.row,
  });

  @override
  String toString() {
    return 'section_${section}_row_$row';
  }
  /*
  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(other) {
    if (other.runtimeType != IndexPath) {
      return false;
    }
    // ignore: test_types_in_equals
    IndexPath otherIndexPath = other as IndexPath;
    return section == otherIndexPath.section && row == otherIndexPath.row;
  }
  */
}
