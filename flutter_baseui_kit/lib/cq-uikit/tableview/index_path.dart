/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-07 13:44:02
 * @Description: 
 */
class IndexPath {
  final int section;
  final int row;
  IndexPath({required this.section, required this.row});
  @override
  String toString() {
    return 'section_${section}_row_$row';
  }

  @override
  int get hashCode => super.hashCode;
  @override
  bool operator ==(other) {
    if (other.runtimeType != IndexPath) {
      return false;
    }
    IndexPath otherIndexPath = other as IndexPath;
    return section == otherIndexPath.section && row == otherIndexPath.row;
  }
}
