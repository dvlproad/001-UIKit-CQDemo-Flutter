/*
 * CreateSectionList1.dart
 *
 * @Description: 分组列表实现方法测试2：以只一个 list 来实现，即将分组 sectionHeader 作为row==-1 的 cell 来在 list 中绘制
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/30 16:52
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSTableViewCell.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSTableViewHeader.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/section_table_view_method2.dart';

class CreateSectionList2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试分组列表的实现方式2:以只一个 list 来实现'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('aa'),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: _pageWidget(),
              ),
            ),
            // Expanded(
            //   child: _pageWidget(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _pageWidget() {
    return CreateSectionTableView2(
      sectionCount: 7,
      numOfRowInSection: (section) {
        return section == 0 ? 3 : 4;
      },
      headerInSection: (section) {
        return CJTSTableViewHeader(title: 'Header $section');
      },
      cellAtIndexPath: (section, row) {
        return CJTSTableViewCell(
          text: 'Cell $section $row',
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
