/*
 * section_table_view.dart
 *
 * @Description: 分组列表实现方法测试2：以只一个 list 来实现，即将分组 sectionHeader 作为row==-1 的 cell 来在 list 中绘制
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/30 17:01
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/material.dart';
import './index_path.dart';
export './index_path.dart';

typedef RowCountInSectionCallBack = int Function(int section);
typedef CellAtIndexPathCallBack = Widget Function(int section, int row);
typedef SectionHeaderCallBack = Widget Function(int section);

class SectionTableView extends StatefulWidget {
  //required
  final int sectionCount;
  final RowCountInSectionCallBack numOfRowInSection;
  final CellAtIndexPathCallBack cellAtIndexPath;

  //section header & divider
  final SectionHeaderCallBack? headerInSection;
  final Widget? divider;

  // controller
  final ScrollController? controller;
  final bool reverse;

  const SectionTableView({
    Key? key,
    required this.sectionCount,
    required this.numOfRowInSection,
    required this.cellAtIndexPath,
    this.headerInSection,
    this.divider,
    this.controller,
    this.reverse = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SectionTableViewState();
  }
}

class _SectionTableViewState extends State<SectionTableView> {
  List<IndexPath> _indexToIndexPathSearch = [];
  // Map<String, double> indexPathToOffsetSearch;

  final listViewKey = GlobalKey();

  // bool showDivider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(SectionTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _indexToIndexPathSearch = [];
    for (int i = 0; i < widget.sectionCount; i++) {
      if (widget.headerInSection != null) {
        _indexToIndexPathSearch.add(IndexPath(section: i, row: -1));
      }

      int rows = widget.numOfRowInSection(i);
      for (int j = 0; j < rows; j++) {
        _indexToIndexPathSearch.add(IndexPath(section: i, row: j));
      }
    }

    return ListView.builder(
      key: listViewKey,
      padding: const EdgeInsets.only(top: 0), // 修复 ListView 没有顶部对齐的问题
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildCell(context, index);
      },
      controller: widget.controller,
      reverse: widget.reverse,
    );
  }

  _buildCell(BuildContext context, int index) {
    if (index >= _indexToIndexPathSearch.length) {
      return null;
    }

    IndexPath indexPath = _indexToIndexPathSearch[index];
    //section header
    if (indexPath.section >= 0 && indexPath.row < 0) {
      return widget.headerInSection!(indexPath.section);
    }

    Widget cell = widget.cellAtIndexPath(indexPath.section, indexPath.row);
    if (widget.divider != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[cell, widget.divider!],
      );
    } else {
      return cell;
    }
  }
}
