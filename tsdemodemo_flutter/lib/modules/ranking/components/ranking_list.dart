import 'package:flutter/cupertino.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_header.dart';
import 'package:tsdemodemo_flutter/modules/ranking/rankling_bean.dart';
import 'package:tsdemodemo_flutter/modules/ranking/components/ranking_list_cell.dart';

typedef ClickRankingItemCallback = void Function();

class RankingList extends StatefulWidget {
  final List<RanklingRowBean> rankingDataModels;
  final ClickRankingItemCallback clickRankingItemCallback;

  RankingList({
    Key key,
    @required this.rankingDataModels,
    this.clickRankingItemCallback,
  }) : super(key: key);

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
    List<RanklingRowBean> topThereBeans = [];
    List<RanklingRowBean> remainingBeans = [];
    if (null != widget.rankingDataModels &&
        widget.rankingDataModels.length > 3) {
      topThereBeans = widget.rankingDataModels.take(3).toList();
      remainingBeans = widget.rankingDataModels.skip(3).toList();
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        RankingListHeader(topThereBeans: topThereBeans),
        Expanded(
          child: sectionTableView(remainingBeans),
        ),
      ],
    );
  }

  Widget sectionTableView(List<RanklingRowBean> rankingDataModels) {
    _rankingSectionMaps = [
      {'values': rankingDataModels}
    ];
    int sectionCount =
        null != _rankingSectionMaps ? _rankingSectionMaps.length : 0;

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
        List<RanklingRowBean> values = sectionModel['values'];
        RanklingRowBean dataModel = values[row];
        return RankingListCell(
          showIndex: true,
          dataModel: dataModel,
          arrowImageType: RankingListCellArrowImageType.none,
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
