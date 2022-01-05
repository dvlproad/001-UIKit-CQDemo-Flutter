import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSAppBarPage extends StatefulWidget {
  TSAppBarPage({
    Key key,
  }) : super(key: key);

  @override
  _TSAppBarPageState createState() => _TSAppBarPageState();
}

class _TSAppBarPageState extends State<TSAppBarPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        //宽高都充满屏幕剩余空间
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFFF0F0F0),
        child: Stack(
          children: [_buildWidget],
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() {
    // return AppBar(
    //   title: Text("AppBar(导航栏3353523)"),
    //   actions: [
    //     IconButton(
    //       icon: Icon(Icons.search),
    //       onPressed: () {
    //         print('search....');
    //       },
    //     ),
    //     IconButton(
    //       icon: Icon(Icons.share),
    //       onPressed: () {
    //         print('share....');
    //       },
    //     ),
    //   ],
    // );
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true, // 标题统一居中(ios下默认居中对对齐,安卓下默认左对齐)
      elevation: 0, //隐藏底部阴影分割线
      // title: AppBarTitleWidget(text: '好友列表'),
      title: Text(
        "好友列表",
        style: TextStyle(
          color: const Color(0xFF222222),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: AppBarBackWidget(
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget get _buildWidget {
    return Column(
      children: [
        Container(color: Colors.white, height: 20),
        CommonAppBar(
          backgroundColor: Colors.transparent,
          title: AppBarTitleWidget(text: '我是有返回按钮的导航栏标题'),
          automaticallyImplyLeading: true,
          leading: AppBarBackWidget(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        CommonAppBar(
          title: AppBarTitleWidget(text: '我是没有返回按钮的导航栏标题'),
          automaticallyImplyLeading: false,
        ),
        appBar(),
        CommonAppBar(
          title: AppBarTitleWidget(
            text: '商品收藏',
            // onPressed: () {
            //   print('点击标题');
            // },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print('search....');
              },
            ),
            AppBarActionWidget(
              image: AssetImage(
                'assets/appbar/icon_search.png',
                package: 'flutter_effect',
              ),
              onPressed: () {
                print('点击管理');
              },
            ),
            AppBarActionWidget(
              text: '地址管理',
              onPressed: () {
                print('点击管理');
              },
            ),
          ],
        ),
      ],
    );
  }
}
