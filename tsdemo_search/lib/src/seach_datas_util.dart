import 'package:flutter_search/util/search_section_bean.dart';
import './search_data_bean.dart';

class TSSearchDataUtil {
  static List<CJSectionDataModel> getSearchSectionDataModels() {
    CJSectionDataModel secctionModel1 = CJSectionDataModel();
    secctionModel1.theme = "A区";
    secctionModel1.values = List();
    for (int i = 0; i < 5; i++) {
      TSSearchDataModel dataModel = TSSearchDataModel();
      dataModel.name = "${i}X透社";
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      dataModel.badgeCount = i * 3;
      secctionModel1.values.add(dataModel);
    }
    secctionModel1.selected = true;

    CJSectionDataModel secctionModel2 = CJSectionDataModel();
    secctionModel2.theme = "B区";
    secctionModel2.values = List();
    for (int i = 0; i < 3; i++) {
      TSSearchDataModel dataModel = TSSearchDataModel();
      dataModel.name = "${i}Y透社";
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      dataModel.badgeCount = i * 3;
      secctionModel2.values.add(dataModel);
    }
    secctionModel2.selected = true;

    CJSectionDataModel secctionModel3 = CJSectionDataModel();
    secctionModel3.theme = "C区";
    secctionModel3.values = List();
    for (int i = 0; i < 4; i++) {
      TSSearchDataModel dataModel = TSSearchDataModel();
      dataModel.name = "${i}Z透社";
      dataModel.imageUrl =
          "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4012764803,2714809145&fm=26&gp=0.jpg";
      dataModel.badgeCount = i * 3;
      secctionModel3.values.add(dataModel);
    }
    secctionModel3.selected = true;

    List<CJSectionDataModel> secctionModels =
        List.from([secctionModel1, secctionModel2, secctionModel3]);
    return secctionModels;
  }
}
