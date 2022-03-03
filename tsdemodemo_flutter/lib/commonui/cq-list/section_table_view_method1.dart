/*
 * section_table_view_method1.dart
 *
 * @Description: 分组列表实现方法测试1：以两个 list 来实现，即 list 中包含一个不滚动的 list 来实现 sectionList
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/30 17:01
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

typedef int RowCountInSectionCallBack(int section);
typedef Widget CellAtIndexPathCallBack(int section, int row);
typedef Widget SectionHeaderCallBack(int section);

class CreateSectionTableView1 extends StatefulWidget {
  //required
  final int sectionCount;
  final RowCountInSectionCallBack numOfRowInSection;
  final CellAtIndexPathCallBack cellAtIndexPath;

  //section header & divider
  final SectionHeaderCallBack headerInSection;
  final Widget divider;

  CreateSectionTableView1({
    Key key,
    @required this.sectionCount,
    @required this.numOfRowInSection,
    @required this.cellAtIndexPath,
    this.headerInSection,
    this.divider,
  }) : super(key: key);
  @override
  _CreateSectionTableView1State createState() =>
      new _CreateSectionTableView1State();
}

class _CreateSectionTableView1State extends State<CreateSectionTableView1> {
//  final sectionLstViewKey = GlobalKey();
//  final listViewKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(CreateSectionTableView1 oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
//      key: sectionLstViewKey,
      itemCount: widget.sectionCount,
      itemBuilder: (BuildContext context, int index) {
        return _sectionWidgets(context, index);
      },
    );
  }

  Widget _sectionWidgets(BuildContext context, int sectionIndex) {
    return Column(
      children: <Widget>[
        widget.headerInSection(sectionIndex),
        ListView.builder(
//            key: listViewKey,
          shrinkWrap: true, //该属性表示是否根据子组件的总长度来设置ListView的长度，默认值为false
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.numOfRowInSection(sectionIndex),
          itemBuilder: (context, index) {
            IndexPath indexPath = IndexPath(section: sectionIndex, row: index);
            return _buildCell(context, indexPath);
          },
        ),
      ],
    );
  }

  _buildCell(BuildContext context, IndexPath indexPath) {
    Widget cell = widget.cellAtIndexPath(indexPath.section, indexPath.row);
    if (widget.divider != null) {
      return Column(
        children: <Widget>[cell, widget.divider],
        mainAxisSize: MainAxisSize.min,
      );
    } else {
      return cell;
    }
  }
}
