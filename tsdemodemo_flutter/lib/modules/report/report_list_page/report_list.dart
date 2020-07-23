import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/sectiontableviewheader.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/main_sub_arrow_tableviewcell.dart';

typedef ClickReportReasonItemCallback = void Function(String reportReasonString);

class ReportSectionTableView extends StatefulWidget {
  final List sectionModels;
  final ClickReportReasonItemCallback clickReportReasonItemCallback;

  ReportSectionTableView({
    Key key,
    this.sectionModels,
    this.clickReportReasonItemCallback,
  })  :  super(key: key);

  @override
  _ReportSectionTableViewState createState() => _ReportSectionTableViewState();
}

class _ReportSectionTableViewState extends State<ReportSectionTableView> {
  @override
  Widget build(BuildContext context) {
    return sectionTableView();
  }

  Widget sectionTableView() {
    int sectionCount = widget.sectionModels.isNotEmpty ? widget.sectionModels.length : 0;

    return SectionTableView(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        var sectionModel = widget.sectionModels[section];
        var values = sectionModel['rows'];
        var rowCount = values.length;
        return rowCount;
      },
      headerInSection: (section) {
        var sectionModel = widget.sectionModels[section];
        var theme = sectionModel['message'];
        return TableViewHeader(
          title: theme,
        );
      },
      cellAtIndexPath: (section, row) {
        var sectionModel = widget.sectionModels[section];
        var values = sectionModel['rows'];
        var dataModel = values[row];
        var title = dataModel['message'];
        return MainSubArrowTableViewCell(
          text: title,
          arrowImageType: TableViewCellArrowImageType.arrowRight,
          section: section,
          row: row,
          clickCellCallback: (section, row) =>
          {
            widget.clickReportReasonItemCallback(title)
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
//      cellHeightAtIndexPath: (section, row) => 44.0,
    );
  }
}