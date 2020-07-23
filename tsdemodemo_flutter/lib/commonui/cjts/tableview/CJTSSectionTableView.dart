import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'CJTSTableViewCell.dart';
import 'CJTSTableViewHeader.dart';

class CJTSSectionTableView extends StatefulWidget {
  final List sectionModels;

  CJTSSectionTableView({
    Key key,
    this.sectionModels,
  })  :  super(key: key);

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
        var dataModel = values[row];
        var title = dataModel['title'];
        var nextPageName = dataModel['nextPageName'];
        return CJTSTableViewCell(
          title: title,
          section: section,
          row: row,
          clickCellCallback: (section, row) =>
          {
            this.__dealDataModel(section, row)
          },
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

  void __dealDataModel(section, row) {
    var sectionModel = widget.sectionModels[section];
    var values = sectionModel['values'];
    var dataModel = values[row];
    var title = dataModel['title'];
    var nextPageName = dataModel['nextPageName'];

    Navigator.pushNamed(context, nextPageName);
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => NextPage(), //'A'
////          settings: RouteSettings(arguments: userName),
//      ),
//    );
  }
}