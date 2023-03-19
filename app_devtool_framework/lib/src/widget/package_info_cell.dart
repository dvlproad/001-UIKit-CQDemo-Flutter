import 'dart:math';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import 'package:app_environment/app_environment.dart';
import '../cell/title_value_cell.dart';
import '../dev_branch/dev_branch_page.dart';

class PackageInfoCell extends StatefulWidget {
  final BranchPackageInfo packageInfo;

  const PackageInfoCell({
    Key? key,
    required this.packageInfo,
  }) : super(key: key);

  @override
  _PackageInfoCellState createState() => _PackageInfoCellState();
}

class _PackageInfoCellState extends State<PackageInfoCell> {
  late BranchPackageInfo _packageInfo;

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
    _packageInfo = widget.packageInfo;

    // _packageInfo.buildContainBranchs =
    //     "0.dev_lzh_im_order:im发送订单#1.dev_splash:开屏页样式修改#2.dev_upload:分块上传#3.dev_fix:线上版问题修复或优化#4.dev_lzh_wish_goods:愿望单详情使用新接口#5.dev_asset_unuse:app无用资源清理";
    String version = _packageInfo.version;
    String buildNumber = _packageInfo.buildNumber;
    String branceName = _packageInfo.buildBranceName;
    String buildCreateTime = _packageInfo.buildCreateTime;
    String versionName = "$version($buildNumber)";

    PackageTargetType originTargetType = EnvManagerUtil.originPackageTargetType;
    String originTargetDes =
        EnvManagerUtil.packageTargetString(originTargetType);

    PackageTargetModel originTargetModel =
        EnvManagerUtil.packageDefaultTargetModel;

    TSEnvNetworkModel originNetworkModel =
        EnvManagerUtil.packageDefaultNetworkModel;
    String originNetworkDes =
        originNetworkModel.type.toString().split('.').last;
    originNetworkDes += "_${originNetworkModel.name}";

    String appTargetNetworkDes = EnvManagerUtil.appTargetNetworkString(
      containLetter: false,
    );

    // String versionName = "formal_product：V1.02.25(22221010)";

    // return ImageTitleTextValueCell(
    //   title: "app信息",
    //   textValue: versionName,
    //   textValueFontSize: 12,
    //   onTap: () {
    //     Clipboard.setData(ClipboardData(text: versionName));
    //     ToastUtil.showMessage('app信息拷贝成功');
    //   },
    // );

    String packageBranchLog = _packageInfo.getBuildContainBranchsDescription(
      showBranchName: false,
    );
    int currentBranchCount = _packageInfo.buildContainBranchs.length;

    String packUploadLocationLog = '';
    if (_packageInfo.packResultModel != null) {
      PackResultModel packResultModel = _packageInfo.packResultModel!;
      packUploadLocationLog += '${packResultModel.pgyerOwner!}';

      String? pgyerChannelShortcut =
          packResultModel.pgyerChannelConfigModel?.pgyerChannelShortcut_upload;
      if (pgyerChannelShortcut != null) {
        packUploadLocationLog += '_${pgyerChannelShortcut!}';
      } else {
        packUploadLocationLog += '_all';
      }
    }

    String packDownloadLocationLog = '';
    if (_packageInfo.packResultModel != null) {
      PackResultModel packResultModel = _packageInfo.packResultModel!;
      packDownloadLocationLog += '${packResultModel.pgyerOwner}';

      String? pgyerChannelShortcut = packResultModel
          .pgyerChannelConfigModel?.pgyerChannelShortcut_download;
      if (pgyerChannelShortcut != null) {
        packDownloadLocationLog += '_${pgyerChannelShortcut!}';
      } else {
        packDownloadLocationLog += '_all';
      }
    }

    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ImageTitleTextValueCell(
              height: 40,
              title: "app信息(${appTargetNetworkDes})",
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
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          TitleValueCellFactory.rowCellWidget(
                            title: "①包与版本",
                            textValue: versionName,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "②原始平台",
                            textValue: originTargetDes,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "②原始环境",
                            textValue: originNetworkDes,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "③来源分支",
                            textValue: branceName,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "④生成时间",
                            textValue: buildCreateTime,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "⑤功能涵盖",
                            textValue: _packageInfo.buildBranceFeature,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "⑥上传位置",
                            textValue: packUploadLocationLog,
                            textValueFontSize: 12,
                            textValueMaxLines: 20,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "⑥下载位置",
                            textValue: packDownloadLocationLog,
                            textValueFontSize: 12,
                            textValueMaxLines: 20,
                          ),
                          TitleValueCellFactory.rowCellWidget(
                            title: "⑦打包信息",
                            textValue: _packageInfo.buildDescription,
                            textValueFontSize: 12,
                          ),
                          TitleValueCellFactory.columnCellWidget(
                            title: "⑧分支信息",
                            textValue: packageBranchLog,
                            textValueFontSize: 12,
                            textValueMaxLines: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  TitleValueCellFactory.arrowImage(),
                ],
              ),
            ),
          ],
        ),
      ),
      onLongPress: throttle(() async {
        String _brancesRecordTime = _packageInfo.buildCreateTime;
        List<DevBranchBean> _devBranchBeans = _packageInfo.buildContainBranchs;
        if (_devBranchBeans.isEmpty) {
          ToastUtil.showMessage('暂无分支信息');
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DevBranchPage(
            brancesRecordTime: _brancesRecordTime,
            devBranchBeans: _devBranchBeans,
          );
        }));
      }),
      onTap: throttle(() async {
        String packageTypeDes = EnvManagerUtil.packageDefaultNetworkModel.des;
        String fullPackageDes = '';
        fullPackageDes += "$packageTypeDes：";
        fullPackageDes += "${_packageInfo.fullPackageDes()}";

        Clipboard.setData(ClipboardData(text: fullPackageDes));
        ToastUtil.showMessage('app信息拷贝成功');
      }),
    );
  }
}
