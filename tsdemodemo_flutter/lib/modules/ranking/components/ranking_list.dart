import 'package:flutter/cupertino.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_bean.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_cell.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_header.dart';

typedef ClickRankingItemCallback = void Function();

class RankingList extends StatefulWidget {
  //final List<Map<String, dynamic>> rankingDataMaps;
  final List<RankingBean> rankingDataModels;
  final ClickRankingItemCallback clickRankingItemCallback;

  RankingList({
    Key key,

    @required this.rankingDataModels,
    this.clickRankingItemCallback,
  })  :  super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RankingListState();
  }
}

class _RankingListState extends State<RankingList> {
  List<Map<String, dynamic>> _rankingSectionMaps = [];
  //List<RankingBean> _rankingSectionModels = [];

  @override
  Widget build(BuildContext context) {
    return sectionTableView();
  }

  Widget sectionTableView() {
    _rankingSectionMaps = [{'values': widget.rankingDataModels}];
    int sectionCount = null != _rankingSectionMaps ? _rankingSectionMaps.length : 0;

    return SectionTableView(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        var sectionModel = _rankingSectionMaps[section];
        var values = sectionModel['values'];
        var rowCount = values.length;
        return rowCount;
      },
//      headerInSection: (section) {
//        var sectionModel = _rankingSectionModels[section];
//        var theme = sectionModel['theme'];
//        return RankingListHeader(
//          title: theme,
//        );
//      },
      cellAtIndexPath: (section, row) {
        var sectionModel = _rankingSectionMaps[section];
        var values = sectionModel['values'];
        var dataModel = values[row];
        return RankingListCell(
          showIndex: true,
          dataModel: dataModel,
          arrowImageType: RankingListCellArrowImageType.arrowRight,
          section: section,
          row: row,
          clickCellCallback: (section, row) {
            return widget.clickRankingItemCallback();
          },
        );
      },
//      divider: Container(
//        color: Colors.green,
//        height: 1.0,
//      ),
      //SectionTableController
//      sectionHeaderHeight: (section) => 125.0,
//      dividerHeight: () => 1.0,
//      cellHeightAtIndexPath: (section, row) => 90.0,
    );
  }
}