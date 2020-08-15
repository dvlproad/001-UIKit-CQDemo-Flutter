class CJSectionDataModel {
  int type;
  String theme;
  List<dynamic> values;
  bool selected;
}

class CJSearchDataBaseModel {
  bool isSearchResult; // 是否是搜索出来
  bool isContainInSelf; // 搜索的字符串在本身包含
  bool isContainInMembers; // 搜索的字符串在本身的成员中包含(如果有成员)
  List containMembers; // 包含的内容

//@property (nonatomic, assign) NSMutableArray *comeFrom;/**< 包含的内容 */
}

class TSSearchDataModel extends CJSearchDataBaseModel {
  String name;
  String imageUrl;
  int badgeCount;

  TSSearchDataModel({
    this.name,
    this.imageUrl =
        'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg',
    this.badgeCount,
  });
}
