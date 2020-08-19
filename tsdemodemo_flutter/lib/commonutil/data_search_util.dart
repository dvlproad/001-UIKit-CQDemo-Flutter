import 'package:tsdemodemo_flutter/modules/search/search_data_bean.dart';

enum CJSearchType {
  CJSearchTypeFull, /// 检查整个字符串
  CJSearchTypeFirstLetterIsFirstCharacter, /**< 检查整个字符串,但必须保证字符串的首字符为搜索的搜字符 */
}

typedef PinyinFromStringBlock = String Function(
    String string); // 字符串转换成拼音的方法/代码块

class CJDataSearchUtil {
//#pragma mark - 在sectionDataModels中搜索(每个sectionDataModel中的values属性值为dataModels数组)
/*
 *  在数据源sectionDataModels中元素中搜索包含searchText的元素，并最终保持sectionDataModels的格式返回（只搜索自身）
 *
 *  @param searchText               要搜索的字串
 *  @param sectionDataModels        要搜索的数据源
 *  @param dataModelSearchSelector  获取元素中要比较的字段的方法
 *  @param searchType               按什么搜索方式搜索
 *  @param supportPinyin            是否支持拼音搜索
 *  @param pinyinFromStringBlock    字符串转换成拼音的方法/代码块
 *
 *  @return 搜索结果(结果中的每个元素是 CJSectionDataModel
 */
  static List searchTextInSectionDataModels(
    String searchText,
    List<CJSectionDataModel> sectionDataModels,
    String dataModelSearchSelector, {
    CJSearchType searchType,
    bool supportPinyin,
    PinyinFromStringBlock pinyinFromStringBlock,
  }) {
    List resultSectionDataModels = List();

    for (CJSectionDataModel sectionDataModel in sectionDataModels) {
      List dataModels = sectionDataModel.values;

      List resultDataModels = CJDataSearchUtil.searchTextInDataModels(
        searchText,
        dataModels,
        dataModelSearchSelector,
        searchType: searchType,
        supportPinyin: supportPinyin,
        pinyinFromStringBlock: pinyinFromStringBlock,
      );

      if (resultDataModels.length > 0) {
        CJSectionDataModel resultSectionDataModel = CJSectionDataModel();
        resultSectionDataModel.type = sectionDataModel.type;
        resultSectionDataModel.theme = sectionDataModel.theme;
        resultSectionDataModel.values = resultDataModels;

        resultSectionDataModels.add(resultSectionDataModel);
      }
    }

    return resultSectionDataModels;
  }

// #pragma mark - 在数组dataModels中搜索
/*
 *  在数据源searchDataSource中搜索是否包含searchText
 *
 *  @param searchText               要搜索的字串
 *  @param dataModels               要搜索的数据源
 *  @param dataModelSearchSelector  获取元素中要比较的字段的方法
 *  @param searchType               按什么搜索方式搜索
 *  @param supportPinyin            是否支持拼音搜索
 *  @param pinyinFromStringBlock    字符串转换成拼音的方法/代码块
 *
 *  @return 搜索结果
 */
  static List searchTextInDataModels(
    String searchText,
    List dataModels,
    String dataModelSearchSelector, {
    CJSearchType searchType,
    bool supportPinyin,
    PinyinFromStringBlock pinyinFromStringBlock,
  }) {
    List searchResults = List();
    if (searchText.length == 0) {
      // [searchResults addObjectsFromArray:dataModels];
      searchResults.addAll(dataModels);
    } else {
      for (dynamic dataModel in dataModels) {
        bool isContainSearchText =
            CJDataSearchUtil.isContainSearchTextInDataModel(
          searchText,
          dataModel,
          dataModelSearchSelector,
          searchType: searchType,
          supportPinyin: supportPinyin,
          pinyinFromStringBlock: pinyinFromStringBlock,
        );
        if (isContainSearchText) {
          searchResults.add(dataModel);
        }
      }
    }

    return searchResults;
  }

// /** 完整的描述请参见文件头部 */
// + (NSMutableArray<NSObject *> *)searchText:(NSString *)searchText
//                               inDataModels:(NSArray<NSObject *> *)dataModels
//                    dataModelSearchSelector:(SEL)dataModelSearchSelector
//            andSearchInEveryDataModelMember:(SEL)dataModelMemberSelector
//              dataModelMemberSearchSelector:(SEL)dataModelMemberSearchSelector
//                             withSearchType:(CJSearchType)searchType
//                              supportPinyin:(BOOL)supportPinyin
//                      pinyinFromStringBlock:(NSString *(^)(NSString *string))pinyinFromStringBlock
// {
//     NSMutableArray *resultDataModels = [[NSMutableArray alloc] init];
//     for (NSObject *dataModel in dataModels) {

//         NSObject *resultDataModel = [CJDataUtil searchText:searchText
//                                                inDataModel:dataModel
//                                    dataModelSearchSelector:dataModelSearchSelector
//                            andSearchInEveryDataModelMember:dataModelMemberSelector
//                              dataModelMemberSearchSelector:dataModelMemberSearchSelector
//                                             withSearchType:searchType
//                                              supportPinyin:supportPinyin
//                                      pinyinFromStringBlock:pinyinFromStringBlock];
//         if (resultDataModel) {
//             [resultDataModels addObject:resultDataModel];
//         }
//     }

//     return resultDataModels;
// }

// #pragma mark - 在dataModel或fromString中搜索
/*
 *  判断dataModel中的dataModelSearchSelector属性，是否包含searchText
 *
 *  @param searchText               要搜索的字串
 *  @param dataModel                要搜索的数据源
 *  @param dataModelSearchSelector  获取元素中要比较的字段的方法
 *  @param searchType               按什么搜索方式搜索
 *  @param supportPinyin            是否支持拼音搜索
 *  @param pinyinFromStringBlock    字符串转换成拼音的方法/代码块
 *
 *  @return 是否包含字串
 */
  static bool isContainSearchTextInDataModel(
    String searchText,
    dynamic dataModel,
    String dataModelSearchSelector, {
    CJSearchType searchType,
    bool supportPinyin,
    PinyinFromStringBlock pinyinFromStringBlock,
  }) {
    // String dataModelSearchSelectorString = [CJDataUtil stringValueForDataSelector:dataModelSearchSelector inDataModel:dataModel];
    String dataModelSearchSelectorString = dataModel.name;

    //搜索判断
    bool isContainSearchText = CJDataSearchUtil.isContainSearchTextFromString(
      searchText,
      dataModelSearchSelectorString,
      searchType: searchType,
      supportPinyin: supportPinyin,
      pinyinFromStringBlock: pinyinFromStringBlock,
    );

    return isContainSearchText;
  }

/*
 *  在fromString中搜索是否包含searchText
 *
 *  @param searchText               要搜索的字串
 *  @param fromString               从哪个字符串搜索
 *  @param searchType               按什么搜索方式搜索
 *  @param supportPinyin            是否支持拼音搜索
 *  @param pinyinFromStringBlock    字符串转换成拼音的方法/代码块
 *
 *  @return 是否包含字串
 */
  static bool isContainSearchTextFromString(
    String searchText,
    String fromString, {
    CJSearchType searchType = CJSearchType.CJSearchTypeFull,
    bool supportPinyin = false,
    PinyinFromStringBlock pinyinFromStringBlock,
  }) {
    if (searchText == null || fromString == null) {
      return false;
    }

    if (searchText.length == 0) {
      return true;
    }

//    if ((fromString.length == 0 && searchText.length != 0)) {
//        return false;
//    }

    List searchSourceStrings = List.from([fromString.toLowerCase()]);
    if (supportPinyin) {
      String searchSourceStringPinyin = pinyinFromStringBlock(fromString);
      searchSourceStrings.add(searchSourceStringPinyin);
    }

    //搜索判断
    bool isContainSearchText = false;
    String searchTextString = searchText.toLowerCase(); //下面比较时候要保证大小写一致
    for (String searchSourceString in searchSourceStrings) {
      String lowerSearchSourceString = searchSourceString.toLowerCase();

      if (CJSearchType.CJSearchTypeFirstLetterIsFirstCharacter == searchType) {
        String searchTextFirstcharacter = searchTextString.substring(
            0, 1); //[searchTextString substringToIndex:1];
        String lowerSearchTextFirstcharacter =
            searchTextFirstcharacter.toLowerCase();
        if (lowerSearchSourceString.startsWith(lowerSearchTextFirstcharacter) ==
            false) {
          isContainSearchText = false;
          continue;
        }
      }

      int location = searchSourceString.indexOf(
          searchTextString); //[searchSourceString rangeOfString:searchTextString].location;
      if (location >= 0) {
        isContainSearchText = true;
        break;
      }
    }

    return isContainSearchText;
  }
}
