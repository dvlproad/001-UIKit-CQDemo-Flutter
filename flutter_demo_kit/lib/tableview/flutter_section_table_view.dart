library flutter_section_table_view;

import 'package:flutter/material.dart';
import 'dart:math';

typedef int RowCountInSectionCallBack(int section);
typedef Widget CellAtIndexPathCallBack(int section, int row);
typedef Widget SectionHeaderCallBack(int section);
typedef double SectionHeaderHeightCallBack(int section);
typedef double DividerHeightCallBack();
typedef double CellHeightAtIndexPathCallBack(int section, int row);
typedef void SectionTableViewScrollToCallBack(
    int section, int row, bool isScrollDown);

class IndexPath {
  final int section;
  final int row;
  IndexPath({required this.section, required this.row});
  @override
  String toString() {
    return 'section_${section}_row_$row';
  }

  @override
  int get hashCode => super.hashCode;
  @override
  bool operator ==(other) {
    if (other.runtimeType != IndexPath) {
      return false;
    }
    IndexPath otherIndexPath = other as IndexPath;
    return section == otherIndexPath.section && row == otherIndexPath.row;
  }
}

class SectionTableController extends ChangeNotifier {
  IndexPath topIndex = IndexPath(section: 0, row: -1);
  bool dirty = false;
  bool animate = false;
  SectionTableViewScrollToCallBack? sectionTableViewScrollTo;

  SectionTableController({this.sectionTableViewScrollTo});

  void jumpTo(int section, int row) {
    topIndex = IndexPath(section: section, row: row);
    animate = false;
    dirty = true;
    notifyListeners();
  }

  Future<bool> animateTo(int section, int row) {
    topIndex = IndexPath(section: section, row: row);
    animate = true;
    dirty = true;
    notifyListeners();
    return Future.delayed(Duration(milliseconds: 251), () => true);
  }
}

class SectionTableView extends StatefulWidget {
  //required
  final int sectionCount;
  final RowCountInSectionCallBack numOfRowInSection;
  final CellAtIndexPathCallBack cellAtIndexPath;

  //section header & divider
  final SectionHeaderCallBack? headerInSection;
  final Widget? divider;

  //tell me cell & header & divider height, so that I can scroll to specific index path
  //work with SectionTableController
  final SectionHeaderHeightCallBack?
      sectionHeaderHeight; // must set when use SectionTableController
  final DividerHeightCallBack?
      dividerHeightBlock; // must set when use SectionTableController
  final CellHeightAtIndexPathCallBack?
      cellHeightAtIndexPath; // must set when use SectionTableController
  final SectionTableController?
      controller; //you can use this controller to scroll section table view

  final ScrollController _scrollController;
  ScrollController get scrollController => _scrollController;

  SectionTableView({
    Key? key,
    required this.sectionCount,
    required this.numOfRowInSection,
    required this.cellAtIndexPath,
    this.headerInSection,
    this.divider,
    this.sectionHeaderHeight,
    this.dividerHeightBlock,
    this.cellHeightAtIndexPath,
    this.controller,
  })  : _scrollController = ScrollController(),
        super(key: key);
  @override
  _SectionTableViewState createState() => new _SectionTableViewState();
}

class _SectionTableViewState extends State<SectionTableView> {
  List<IndexPath> indexToIndexPathSearch = [];
  late Map<String, double> indexPathToOffsetSearch;

  final listViewKey = GlobalKey();

  //scroll position check
  int? currentIndex;
  double? preIndexOffset;
  double? nextIndexOffset;

  bool showDivider = false;

  double? scrollOffsetFromIndex(IndexPath indexPath) {
    var offset = indexPathToOffsetSearch[indexPath.toString()];
    if (offset == null) {
      return null;
    }
    final contentHeight = indexPathToOffsetSearch[
        IndexPath(section: widget.sectionCount, row: -1).toString()];

    if (listViewKey.currentContext != null && contentHeight != null) {
      double listViewHeight = listViewKey.currentContext?.size?.height ?? 0;

      if (offset + listViewHeight > contentHeight) {
        // avoid over scroll(bounds)
        return max(0.0, contentHeight - listViewHeight);
      }
    }

    return offset;
  }

  void calculateIndexPathAndOffset() {
    if (widget.sectionCount == 0) {
      return;
    }
    //calculate index to indexPath mapping
    showDivider = false;
    bool showSectionHeader = false;
    if (widget.divider != null) {
      showDivider = true;
    }
    if (widget.headerInSection != null) {
      showSectionHeader = true;
    }

    indexToIndexPathSearch = [];
    for (int i = 0; i < widget.sectionCount; i++) {
      if (showSectionHeader) {
        indexToIndexPathSearch.add(IndexPath(section: i, row: -1));
      }
      int rows = widget.numOfRowInSection(i);
      for (int j = 0; j < rows; j++) {
        indexToIndexPathSearch.add(IndexPath(section: i, row: j));
      }
    }

    if (widget.controller == null) {
      return;
    }

    //only execute below when user want count height and scroll to specific index path
    //calculate indexPath to offset mapping
    indexPathToOffsetSearch = {};
    final sectionController = widget.controller;
    if ((showSectionHeader && widget.sectionHeaderHeight == null) ||
        (showDivider && widget.dividerHeightBlock == null) ||
        widget.cellHeightAtIndexPath == null) {
      print(
          '''error: if you want to use controller to scroll SectionTableView to wanted index path, 
               you need to pass parameters: 
               [sectionHeaderHeight][dividerHeight][cellHeightAtIndexPath]''');
    } else {
      double offset = 0.0;
      double dividerHeight = showDivider ? widget.dividerHeightBlock!() : 0.0;
      for (int i = 0; i < widget.sectionCount; i++) {
        if (showSectionHeader) {
          indexPathToOffsetSearch[IndexPath(section: i, row: -1).toString()] =
              offset;
          offset += widget.sectionHeaderHeight!(i);
        }
        int rows = widget.numOfRowInSection(i);
        for (int j = 0; j < rows; j++) {
          indexPathToOffsetSearch[IndexPath(section: i, row: j).toString()] =
              offset;
          offset += widget.cellHeightAtIndexPath!(i, j) + dividerHeight;
        }
      }
      indexPathToOffsetSearch[IndexPath(section: widget.sectionCount, row: -1)
          .toString()] = offset; //list view length
    }

    //calculate initial scroll offset
//      double initialOffset = scrollOffsetFromIndex(widget.controller.topIndex);
//      if (initialOffset == null) {
//        initialOffset = 0.0;
//      }

    int findValidIndexPathByIndex(int index, int pace) {
      for (int i = index + pace;
          (i >= 0 && i < indexToIndexPathSearch.length);
          i += pace) {
        final indexPath = indexToIndexPathSearch[i];
        if (indexPath.section >= 0) {
          return i;
        }
      }
      return index;
    }

    if (indexToIndexPathSearch.length == 0) {
      return;
    }

    if (indexPathToOffsetSearch != null) {
      currentIndex = 0;
      for (int i = 0; i < indexToIndexPathSearch.length; i++) {
        if (indexToIndexPathSearch[i] == sectionController!.topIndex) {
          currentIndex = i;
        }
      }

//      final preIndexPath = findValidIndexPathByIndex(currentIndex, -1);
      final currentIndexPath = indexToIndexPathSearch[currentIndex!];
      final nextIndexPath =
          indexToIndexPathSearch[findValidIndexPathByIndex(currentIndex!, 1)];
      preIndexOffset = indexPathToOffsetSearch[currentIndexPath.toString()];
      nextIndexOffset = indexPathToOffsetSearch[nextIndexPath.toString()];
    }

    //init scroll controller
    widget.controller!.addListener(() {
      //listen section table controller to scroll the list view
      if (sectionController!.dirty) {
        sectionController!.dirty = false;
        double? offset = scrollOffsetFromIndex!(sectionController!.topIndex);
        if (offset == null) {
          return;
        }
        if (sectionController!.animate) {
          widget.scrollController.animateTo(offset,
              duration: Duration(milliseconds: 250), curve: Curves.decelerate);
        } else {
          widget.scrollController.jumpTo(offset);
        }
      }
    });
    //listen scroll controller to feedback current index path
    if (indexPathToOffsetSearch != null) {
      widget.scrollController.addListener(() {
        double currentOffset = widget.scrollController.offset;
//        print('scroll offset $currentOffset');
        if (currentOffset < preIndexOffset!) {
          //go previous cell
          if (currentIndex! > 0) {
            final nextIndexPath = indexToIndexPathSearch[currentIndex!];
            currentIndex = findValidIndexPathByIndex(currentIndex!, -1);
            final currentIndexPath = indexToIndexPathSearch[currentIndex!];
            preIndexOffset =
                indexPathToOffsetSearch[currentIndexPath.toString()];
            nextIndexOffset = indexPathToOffsetSearch[nextIndexPath.toString()];
//            print('go previous index $currentIndexPath');
            if (widget.controller!.sectionTableViewScrollTo != null) {
              widget.controller!.sectionTableViewScrollTo!(
                  currentIndexPath.section, currentIndexPath.row, false);
            }
          }
        } else if (currentOffset >= nextIndexOffset!) {
          //go next cell
          if (currentIndex! < indexToIndexPathSearch.length - 2) {
            currentIndex = findValidIndexPathByIndex(currentIndex!, 1);
            final currentIndexPath = indexToIndexPathSearch[currentIndex!];
            final nextIndexPath = indexToIndexPathSearch[
                findValidIndexPathByIndex(currentIndex!, 1)];
            preIndexOffset =
                indexPathToOffsetSearch[currentIndexPath.toString()];
            nextIndexOffset = indexPathToOffsetSearch[nextIndexPath.toString()];
//            print('go next index $currentIndexPath');
            if (widget.controller!.sectionTableViewScrollTo != null) {
              widget.controller!.sectionTableViewScrollTo!(
                  currentIndexPath.section, currentIndexPath.row, true);
            }
          }
        }
      });
    }
  }

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

  _buildCell(BuildContext context, int index) {
    if (index >= indexToIndexPathSearch.length) {
      return null;
    }

    IndexPath indexPath = indexToIndexPathSearch[index];
    //section header
    if (indexPath.section >= 0 && indexPath.row < 0) {
      return widget.headerInSection!(indexPath.section);
    }

    Widget cell = widget.cellAtIndexPath(indexPath.section, indexPath.row);
    if (showDivider) {
      return Column(
        children: <Widget>[cell, widget.divider!],
        mainAxisSize: MainAxisSize.min,
      );
    } else {
      return cell;
    }
  }

  void _onOffsetCallback(bool isUp, double offset) {
    // if you want change some widgets state ,you should rewrite the callback
  }

  @override
  Widget build(BuildContext context) {
    calculateIndexPathAndOffset();

    return ListView.builder(
      key: listViewKey,
      physics: AlwaysScrollableScrollPhysics(),
      controller: widget.scrollController,
      itemBuilder: (context, index) {
        return _buildCell(context, index);
      },
    );
  }
}
