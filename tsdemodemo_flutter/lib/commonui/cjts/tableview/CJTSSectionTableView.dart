import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'CJTSTableViewCell.dart';
import 'CJTSTableViewHeader.dart';

typedef ClickTSItemCallback = void Function();

class CJTSSectionTableView extends StatefulWidget {
  final BuildContext context;
  final List sectionModels;

  CJTSSectionTableView({
    Key key,
    this.context,
    this.sectionModels,
  }) : super(key: key);

  @override
  _CJTSSectionTableViewState createState() => _CJTSSectionTableViewState();
}

class _CJTSSectionTableViewState extends State<CJTSSectionTableView> {
  @override
  Widget build(BuildContext context) {
    return sectionTableView();
  }

  Widget sectionTableView() {
    int sectionCount = widget.sectionModels.length;

    return SectionTableView(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        var sectionModel = widget.sectionModels[section];
        var values = sectionModel['values'];
        var rowCount = values.length;
        return rowCount;
      },
      headerInSection: (section) {
        var sectionModel = widget.sectionModels[section];
        String theme = sectionModel['theme'] ?? '';
        return CJTSTableViewHeader(
          title: theme,
        );
      },
      cellAtIndexPath: (section, row) {
        var sectionModel = widget.sectionModels[section];
        var values = sectionModel['values'];
        var moduleModel = values[row];
        var title = moduleModel['title'] ?? '';
        var subTitle = moduleModel['detailText'] ?? '';

        return CJTSTableViewCell(
          text: title,
          detailText: subTitle,
          section: section,
          row: row,
          clickCellCallback: (section, row) =>
              {this.__dealDataModel(moduleModel, section, row)},
        );
      },
      divider: Container(
        color: Colors.green,
        height: 1.0,
      ),
      //SectionTableController
      sectionHeaderHeight: (section) => 25.0,
      dividerHeight: () => 1.0,
      cellHeightAtIndexPath: (section, row) => 44.0,
    );
  }

  void __dealDataModel(moduleModel, int section, int row) {
    ClickTSItemCallback clickTSItemCallback = moduleModel['actionBlock'];
    // // actionBlock 形如：
    // moduleModel['actionBlock'] = () {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => TSImagesBrowserPage(
    //         images: ['1', '2'],
    //         currentIndex: 1,
    //       ),
    //     ),
    //   );
    // };

    if (null != clickTSItemCallback) {
      clickTSItemCallback();
      return;
    }

    String nextPageName = moduleModel['nextPageName'];
    if (null != nextPageName) {
      var title = moduleModel['title'];
      if (nextPageName.startsWith('/', 0) == false) {
        nextPageName = '/report_list_page';
      }

      var params = {'title': title};

      Navigator.pushNamed(widget.context, nextPageName, arguments: params);
      return;
    }

    print('你点击了CJTSTableViewCell:' + section.toString() + '_' + row.toString());
  }
}
