/*
 * @Author: dvlproad
 * @Date: 2022-04-06 10:09:31
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 16:55:55
 * @Description: 上拉加载视图
 */
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshFooterGif extends StatelessWidget {
  const RefreshFooterGif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        late Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("上拉加载");
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载失败！请重试~");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("上拉加载");
        } else {
          body = const Text(
            "没有更多了~",
            style: TextStyle(
              fontSize: 13,
              color: Color.fromRGBO(118, 122, 125, 1),
            ),
          );
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
