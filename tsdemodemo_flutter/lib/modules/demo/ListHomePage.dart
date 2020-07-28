import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSTableViewCell.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSTableViewHeader.dart';

class MinList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Min List'),
      ),
      body: SafeArea(
        child: SectionTableView(
          sectionCount: 7,
          numOfRowInSection: (section) {
            return section == 0 ? 3 : 4;
          },
          headerInSection: (section) {
            return header('Header $section');
          },
          cellAtIndexPath: (section, row) {
            return cellWidget(context, 'Cell $section $row', section, row);
          },
          divider: Container(
            color: Colors.green,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget header(title) {
    return CJTSTableViewHeader(
      title: title,
    );
  }

  Widget cellWidget(context, title, section, row) {
    return CJTSTableViewCell(
      title: title,
      section: section,
      row: row,
      clickCellCallback: (section, row)=>{
        this.__goNextPage(context, section, row)
      },
    );
  }

  void __goNextPage(context, section, row) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MinList(),
//          settings: RouteSettings(arguments: userName),
      ),
    );
  }
}


class SectionList extends StatelessWidget {
  final controller = SectionTableController(sectionTableViewScrollTo: (section, row, isScrollDown) {
    print('received scroll to $section $row scrollDown:$isScrollDown');
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Section List'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text('Scroll'), Icon(Icons.keyboard_arrow_down)],
          ),
          onPressed: () {
            controller.animateTo(2, -1).then((complete) {
              print('animated $complete');
            });
          }),
      body: SafeArea(
        child: SectionTableView(
          sectionCount: 7,
          numOfRowInSection: (section) {
            return section == 0 ? 3 : 4;
          },
          headerInSection: (section) {
            return header('Header $section');
          },
          cellAtIndexPath: (section, row) {
            return cellWidget(context, 'Cell $section $row', section, row);
          },
          divider: Container(
            color: Colors.green,
            height: 1.0,
          ),
          controller: controller, //SectionTableController
          sectionHeaderHeight: (section) => 25.0,
          dividerHeight: () => 1.0,
          cellHeightAtIndexPath: (section, row) => 44.0,
        ),
      ),
    );
  }


  Widget header(title) {
    return CJTSTableViewHeader(
      title: title,
    );
  }

  Widget cellWidget(context, title, section, row) {
    return CJTSTableViewCell(
      title: title,
      section: section,
      row: row,
      clickCellCallback: (section, row)=>{
        this.__goNextPage(context, section, row)
      },
    );
  }

  void __goNextPage(context, section, row) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MinList(),
//          settings: RouteSettings(arguments: userName),
      ),
    );
  }
}



class FullList extends StatefulWidget {
  final String title;

  FullList({Key key, this.title});

  @override
  _FullListState createState() => _FullListState();
}

class _FullListState extends State<FullList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int sectionCount = 9;
  final controller = SectionTableController(sectionTableViewScrollTo: (section, row, isScrollDown) {
    print('received scroll to $section $row scrollDown:$isScrollDown');
  });
  final refreshController = RefreshController();

  Indicator refreshHeaderBuilder(BuildContext context, int mode) {
    return ClassicIndicator(
      mode: mode,
      releaseText: '释放以刷新',
      refreshingText: '刷新中...',
      completeText: '完成',
      failedText: '失败',
      idleText: '下拉以刷新',
      noDataText: '',
    );
  }

  Indicator refreshFooterBuilder(BuildContext context, int mode) {
    return ClassicIndicator(
      mode: mode,
      releaseText: '释放以加载',
      refreshingText: '加载中...',
      completeText: '加载完成',
      failedText: '加载失败',
      idleText: '上拉以加载',
      noDataText: '',
      idleIcon: const Icon(Icons.arrow_upward, color: Colors.grey),
      releaseIcon: const Icon(Icons.arrow_downward, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full List'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Text('Scroll'), Icon(Icons.keyboard_arrow_down)],
          ),
          onPressed: () {
            controller.animateTo(2, -1).then((complete) {
              print('animated $complete');
            });
          }),
      body: SafeArea(
        child: SectionTableView(
          refreshHeaderBuilder: refreshHeaderBuilder,
          refreshFooterBuilder: refreshFooterBuilder,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: (up) {
            print('on refresh $up');

            Future.delayed(const Duration(milliseconds: 2009)).then((val) {
              refreshController.sendBack(up, RefreshStatus.completed);
              setState(() {
                if (up) {
                  sectionCount = 5;
                } else {
                  sectionCount++;
                }
              });
            });
          },
          refreshController: refreshController,
          sectionCount: sectionCount,
          numOfRowInSection: (section) {
            return section == 0 ? 3 : 4;
          },
          headerInSection: (section) {
            return header('Header $section');
          },
          cellAtIndexPath: (section, row) {
            return cellWidget('Cell $section $row', section, row);
          },
          divider: Container(
            color: Colors.green,
            height: 1.0,
          ),
          controller: controller, //SectionTableController
          sectionHeaderHeight: (section) => 25.0,
          dividerHeight: () => 1.0,
          cellHeightAtIndexPath: (section, row) => 44.0,
        ),
      ),
    );
  }

  Widget header(title) {
    return CJTSTableViewHeader(
      title: title,
    );
  }

  Widget cellWidget(title, section, row) {
    return CJTSTableViewCell(
      title: title,
      section: section,
      row: row,
      clickCellCallback: (section, row)=>{
        this.__goNextPage(section, row)
      },
    );
  }

  void __goNextPage(section, row) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MinList(),
//          settings: RouteSettings(arguments: userName),
      ),
    );
  }
}