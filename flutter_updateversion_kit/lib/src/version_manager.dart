class VersionManager {
  bool _firstShow;

  static final VersionManager _instance = VersionManager._internal();
  factory VersionManager() => _instance;
  static VersionManager get instance => _instance;
  VersionManager._internal() {
    _firstShow = true;
  }

  bool get firstSHow => _firstShow;
  void setFirstShow(bool b) {
    this._firstShow = b;
  }
}
