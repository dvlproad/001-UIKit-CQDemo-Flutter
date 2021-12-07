import 'package:flutter/material.dart';
import './my_info_cell.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({Key key}) : super(key: key);

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  Map selectArea = null;
  String currentAddress;

  String currentBirthdayString;
  String currentIntro; // 简介

  String currentSexString = '男';
  String currentNickname = '昵称';
  String currentAvatar =
      "https://cdn3-banquan.ituchong.com/weili/l/1073188615191658529.jpeg";

  TextEditingController addressCtr = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("各种Cell"),
      ),
      body: Center(
        child: contentWidget(context),
      ),
    );
  }

  Widget contentWidget(BuildContext context) {
    // return Text('没有匹配的搜索结果22');
    // return Column(
    //   children: [
    //     Expanded( // Expanded 要再Row或者Column 使用才行
    //       child: Text('没有匹配的搜索结果33'),
    //     )
    //   ],
    // );
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Color(0xFFF0F0F0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                BJHTitleImageValueCell(
                    title: "头像", imageValue: currentAvatar, onTap: () {}),
                // 昵称
                // BJHTitleTextInputValueCell(
                //   title: "昵称",
                //   textInputValue: currentNickname,
                //   controller: addressCtr,
                //   onTap: () {},
                // ),
                // 性别
                BJHTitleTextValueCell(
                    title: "性别", textValue: currentSexString, onTap: () {}),
                // 我的二维码
                // BJHTitleImageValueCell(
                //   title: "我的二维码",
                //   imageValue:
                //       "https://cdn3-banquan.ituchong.com/weili/l/1073188615191658529.jpeg",
                //   onTap: () {},
                // ),
                // 生日
                BJHTitleTextValueCell(
                  title: "生日",
                  textValue: currentBirthdayString,
                  textThemeIsRed: true,
                  addDotForValue: true,
                  onTap: () {},
                ),
                TextField(
                  // controller: controller,
                  textAlign: TextAlign.start,
                  maxLength: 100,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "小区楼栋/乡村名称",
                    contentPadding: EdgeInsets.only(left: 1, right: 1, top: 13),
                    border: InputBorder.none,
                    hintStyle:
                        TextStyle(color: Color(0xFF767A7D), fontSize: 13),
                  ),
                ),
                // 地区
                BJHTitleTextValueCell(
                  title: "地区",
                  textValue: currentAddress,
                  onTap: () {},
                ),
                // 简介
                BJHTitleTextInputValueCell(
                  title: "简介",
                  textInputValue: currentIntro,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
