/*
 * CreateSectionList1.dart
 *
 * @Description: 分组列表实现方法测试1：以两个 list 来实现，即 list 中包含一个不滚动的 list 来实现 sectionList
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/30 16:52
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSTableViewCell.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSTableViewHeader.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/section_table_view_method1.dart';

class CreateSectionList1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试分组列表的实现方式1'),
      ),
      body: SafeArea(
        child: _pageWidget(),
      ),
    );
  }

  Widget _pageWidget() {
    return CreateSectionTableView1(
      sectionCount: 7,
      numOfRowInSection: (section) {
        return section == 0 ? 3 : 4;
      },
      headerInSection: (section) {
        return CJTSTableViewHeader(title: 'Header $section');
      },
      cellAtIndexPath: (section, row) {
        return CJTSTableViewCell(
          title: 'Cell $section $row',
          section: section,
          row: row,
          clickCellCallback: (section, row) {
            print('点击界面');
          },
        );
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}