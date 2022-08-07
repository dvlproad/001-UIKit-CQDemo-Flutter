/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-07 13:48:06
 * @Description: 包含标题文本title，值输入框textInputValue(文本前可设置是否添加点来突出)、箭头类型固定为向右 的视图
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './title_commonValue_cell.dart';

class BJHTitleTextInputValueCell extends StatelessWidget {
  final String title; // 标题
  final String? textInputValue; // 值文本（此值为空时候，视图会自动隐藏）
  final TextEditingController? controller;
  final void Function()? onTap; // 点击事件

  BJHTitleTextInputValueCell({
    Key? key,
    required this.title,
    this.textInputValue,
    this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BJHTitleCommonValueTableViewCell(
      title: this.title,
      valueWidgetBuilder: (BuildContext bContext,
              {required bool canExpanded}) =>
          _textInputValueWidget(bContext, canExpanded: canExpanded),
      arrowImageType: TableViewCellArrowImageType.arrowRight,
      onTapCell: ({int? section, int? row}) {
        if (this.onTap != null) {
          this.onTap!();
        }
      },
    );
  }

  Widget? _textInputValueWidget(
    BuildContext bContext, {
    bool canExpanded = false,
  }) {
    return Row(
      children: [_textField()],
    );
  }

  // 输入框
  Widget _textField() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.textInputValue ?? '',
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.red,
          fontSize: AdaptCJHelper.setWidth(30),
          fontWeight: FontWeight.w500,
        ),
      ),
      // child: TextField(
      //   controller: controller,
      //   textAlign: TextAlign.start,
      //   maxLength: 100,
      //   maxLines: 5,
      //   decoration: const InputDecoration(
      //     hintText: "小区楼栋/乡村名称",
      //     contentPadding: EdgeInsets.only(left: 1, right: 1, top: 13),
      //     border: InputBorder.none,
      //     hintStyle: TextStyle(color: Color(0xFF767A7D), fontSize: 13),
      //   ),
      // ),
    );
  }
}
