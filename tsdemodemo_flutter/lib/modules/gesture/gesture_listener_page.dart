
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GestureListenerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _pageWidget(context),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('Listener'),
    );
  }

  Widget _pageWidget(context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.red,
          child: _listenerWidget(
            msg: 'HitTestBehavior.deferToChild',
            behavior: HitTestBehavior.deferToChild,
            child: _pageCellWidget(context),
          ),
        ),
        Container(
          color: Colors.green,
          child: _listenerWidget(
            msg: 'HitTestBehavior.opaque',
            behavior: HitTestBehavior.opaque,
            child: _pageCellWidget(context),
          ),
        ),
        Container(
          color: Colors.blue,
          child: _listenerWidget(
            msg: 'HitTestBehavior.translucent',
            behavior: HitTestBehavior.translucent,
            child: _pageCellWidget(context),
          ),
        ),
      ],
    );
  }

  Widget _listenerWidget({String msg, HitTestBehavior behavior, Widget child}) {
    return Listener(
      // 按下手指回调
      onPointerDown: (PointerDownEvent event){
        print("\n");
        print("${msg} onPointerDown 按下手指回调");
      },
      // 移动手指回调
      onPointerMove: (PointerMoveEvent event){
        print("${msg} onPointerMove 移动手指回调");
      },
      // 抬起手指回调
      onPointerUp: (PointerUpEvent event){
        print("${msg} onPointerUp 抬起手指回调");
      },
      // 取消回调
      onPointerCancel: (PointerCancelEvent event){
        print("${msg} onPointerCancel 取消回调");
      },
      // 该对象在触摸发生时回调
      onPointerSignal: (PointerSignalEvent event){
        print("${msg} onPointerSignal 该对象在触摸发生时回调");
      },
      // 命中测试期间的行为方式")
      behavior: behavior,
      child: Column(
        children: <Widget>[
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 20)),
          child,
        ],
      ),
    );
  }

  Widget _pageCellWidget(context) {
  return AbsorbPointer(
      absorbing: false,
      child: Column(
        children: <Widget>[
          RaisedButton(
            child: Text('正常按钮'),
            onPressed: (){
              print('点击【正常按钮】');
              },
          ),
          AbsorbPointer(
            absorbing: true,
            child: RaisedButton(
              child: Text('无法点击的【AbsorbPointer按钮(absorbing:true默认)】'),
              onPressed: (){
                print('无法点击【AbsorbPointer按钮(absorbing:true默认)】');
              },
            ),
          ),
          AbsorbPointer(
            absorbing: false,
            child: RaisedButton(
              child: Text('可点击的【AbsorbPointer按钮(absorbing:false)】'),
              onPressed: (){
                print('点击【AbsorbPointer按钮(absorbing:false)】');
              },
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: RaisedButton(
              child: Text('无法点击的【IgnorePointer按钮(ignoring:true)】'),
              onPressed: (){
                print('无法点击【IgnorePointer按钮(ignoring:true默认)】');
              },
            ),
          ),
          IgnorePointer(
            ignoring: false,
            child: RaisedButton(
              child: Text('可点击的【IgnorePointer按钮(ignoring:false)】'),
              onPressed: (){
                print('点击【IgnorePointer按钮(ignoring:false)】');
              },
            ),
          ),

        ],
      ),
    );
    }
}
