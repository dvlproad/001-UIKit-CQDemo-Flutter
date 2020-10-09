class IndexPath {
  final int section;
  final int row;
  IndexPath({this.section, this.row});
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
    IndexPath otherIndexPath = other;
    return section == otherIndexPath.section && row == otherIndexPath.row;
  }
}