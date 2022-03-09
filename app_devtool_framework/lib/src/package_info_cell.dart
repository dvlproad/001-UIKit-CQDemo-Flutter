import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import './init/main_diff_util.dart';

class PackageInfoCell extends StatefulWidget {
  final BranchPackageInfo packageInfo;

  const PackageInfoCell({
    Key key,
    this.packageInfo,
  }) : super(key: key);

  @override
  _PackageInfoCellState createState() => _PackageInfoCellState();
}

class _PackageInfoCellState extends State<PackageInfoCell> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BranchPackageInfo packageInfo = widget.packageInfo;
    packageInfo ??= BranchPackageInfo.nullPackageInfo;

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String branceName = packageInfo.buildBranceName;
    String buildCreateTime = packageInfo.buildCreateTime;

    String packageType = MainDiffUtil.diffPackageBean().des;
    String versionName = "$packageType：V$version($buildNumber)";
    // String versionName = "测试包：V1.02.25(22221010)";

    // return BJHTitleTextValueCell(
    //   title: "app信息",
    //   textValue: versionName,
    //   textValueFontSize: 12,
    //   onTap: () {
    //     Clipboard.setData(ClipboardData(text: versionName));
    //     ToastUtil.showMessage('app信息拷贝成功');
    //   },
    // );

    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            BJHTitleTextValueCell(
              height: 40,
              title: "app信息",
              textValue: '',
              arrowImageType: TableViewCellArrowImageType.none,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          cellWidget(
                            title: "①包与版本",
                            textValue: versionName,
                            textValueFontSize: 12,
                          ),
                          cellWidget(
                            title: "②最佳环境",
                            textValue:
                                MainDiffUtil.diffPackageBean().bestNetworkDes,
                            textValueFontSize: 12,
                          ),
                          cellWidget(
                            title: "③生成时间",
                            textValue: buildCreateTime,
                            textValueFontSize: 12,
                          ),
                          cellWidget(
                            title: "④来源分支",
                            textValue: branceName,
                            textValueFontSize: 12,
                          ),
                          cellWidget(
                            title: "⑤功能涵盖",
                            textValue: packageInfo.buildBranceFeature,
                            textValueFontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _arrowImage(),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        String packageTypeDes = MainDiffUtil.diffPackageBean().des;
        String fullPackageDes = '';
        fullPackageDes += "$packageTypeDes：";
        fullPackageDes += "${packageInfo.fullPackageDes()}";

        Clipboard.setData(ClipboardData(text: fullPackageDes));
        ToastUtil.showMessage('app信息拷贝成功');
      },
      onLongPress: () {},
    );
  }

  Widget cellWidget({
    String title,
    String textValue,
    double textValueFontSize,
  }) {
    if (textValue == null || textValue.isEmpty) {
      textValue = '未标明';
    }
    // return BJHTitleTextValueCell(
    //   title: title,
    //   textValue: textValue,
    //   textValueFontSize: textValueFontSize ?? 12,
    // );

    return Container(
      color: Colors.transparent,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _mainText(title),
          Expanded(child: _textValueWidget(textValue)),
        ],
      ),
    );
  }

  // 主文本
  Widget _mainText(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        title ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xff222222),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textValueWidget(String textValue, {double textValueFontSize}) {
    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: const BoxConstraints(maxWidth: 180),
      color: Colors.transparent,
      child: Text(
        textValue ?? '',
        textAlign: TextAlign.right,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xff999999),
          fontSize: textValueFontSize ?? 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // 箭头
  Widget _arrowImage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: const Image(
        image:
            AssetImage('assets/arrow_right.png', package: 'flutter_baseui_kit'),
        width: 17,
        height: 32,
      ),
    );
  }
}
