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
        var theme = sectionModel['theme'];
        return CJTSTableViewHeader(
          title: theme,
        );
      },
      cellAtIndexPath: (section, row) {
        var sectionModel = widget.sectionModels[section];
        var values = sectionModel['values'];
        var moduleModel = values[row];
        var title = moduleModel['title'];

        return CJTSTableViewCell(
          title: title,
          section: section,
          row: row,
          clickCellCallback: (section, row) =>
              {this.__dealDataModel(moduleModel)},
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

  void __dealDataModel(moduleModel) {
    ClickTSItemCallback clickTSItemCallback = moduleModel['actionBlock'];
    if(null != clickTSItemCallback) {
      clickTSItemCallback();

    } else {
      var title = moduleModel['title'];
      String nextPageName = moduleModel['nextPageName'];
      if (nextPageName.startsWith('/', 0) == false) {
        nextPageName = '/report_list_page';
      }

      var params = {'title': title};

      Navigator.pushNamed(widget.context, nextPageName, arguments: params);
    }
  }
}
