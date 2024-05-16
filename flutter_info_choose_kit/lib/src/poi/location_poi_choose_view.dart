/*
 * @Author: dvlproad
 * @Date: 2024-04-19 17:32:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 13:32:23
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter_base_models/flutter_base_models.dart';

// import 'package:tim_ui_kit_lbs_plugin/widget/location_input.dart';
import './location_input.dart';

import './location_poi_cell_widget.dart';

import '../area_picker/base_area_picker_singleton.dart';

import '../../flutter_info_choose_kit_adapt.dart';

class LocationPoiChooseView<
    T extends NearbyAddressModel,
    TCityModel extends BaseCityModel<TCityModel>,
    TLocation extends BaseLocationModel,
    TAreaPickerSingleton extends BaseAreaPickerSingleton<TCityModel,
        TLocation>> extends StatelessWidget {
  final double height;
  final List<T> positionModels;
  final TextEditingController textInputController;
  final void Function(String text) textInputChangeBlock;
  Widget Function(BuildContext context)? moreItemBuilder;
  TAreaPickerSingleton? areaPickerSingleton;
  void Function(bool isPickerShowing)? onPickerShowingChange;
  final void Function(
          T? poiAddressModel, AreaPickerAddressModel? areaPickerAddressModel)
      chooseCompleteBack;

  LocationPoiChooseView({
    Key? key,
    required this.height,
    required this.positionModels,
    required this.textInputController,
    required this.textInputChangeBlock,
    this.moreItemBuilder,
    required this.chooseCompleteBack,
  }) : super(key: key);

  // 使用示例： LocationPoiChooseView<AMapPosition, AppCityModel, LocationModel, AppAreaPickerSingleton>.withMore
  LocationPoiChooseView.withMore({
    Key? key,
    required this.height,
    required this.positionModels,
    bool showMore = false,
    this.areaPickerSingleton,
    required this.textInputController,
    required this.textInputChangeBlock,
    required this.onPickerShowingChange,
    required this.chooseCompleteBack,
  }) : super(key: key) {
    if (showMore == true) {
      moreItemBuilder = (context) {
        return GestureDetector(
          onTap: () {
            onPickerShowingChange?.call(true);
            if (areaPickerSingleton == null) {
              debugPrint("areaPickerSingleton == null, 无法进行选择，请先设置");
              return;
            }
            areaPickerSingleton?.showAreaPickerToLocation(
              context: context,
              // height: height,
              showAllCityType: true,
              showAllAreaType: true,
              needLocationIfNull: false,
              onConfirmHandle: (AreaPickerAddressModel areaPickerAddressModel) {
                onPickerShowingChange?.call(false);
                chooseCompleteBack(null, areaPickerAddressModel);
              },
            );
            // PopupUtil.popupBottomWebView(
            //   context: context,
            //   height: height,
            //   webUrl:
            //       "https://bjh-static-1302324914.cos.ap-shanghai.myqcloud.com/wishhouse/protocol/privacy_protocol.html?123",
            // );
          },
          child: Container(
            height: 40.h_pt_cj,
            // color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15.w_pt_cj),
            child: Text(
              "更多其他区域 >",
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
                fontSize: 12.f_pt_cj,
                color: Colors.blue,
              ),
            ),
          ),
        );
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: _renderLocationListContent(context),
    );
  }

  _renderLocationListContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 50.h_pt_cj,
                child: LocationInput(
                  onChange: textInputChangeBlock,
                  controller: textInputController,
                ),
              ),
              Expanded(child: _listWidget(context)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listWidget(BuildContext context) {
    int itemCount = positionModels.length;

    Widget? moreItemWidget = moreItemBuilder?.call(context);
    if (moreItemWidget != null) {
      itemCount += 1;
    }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
          indent: 15.w_pt_cj,
          endIndent: 15.w_pt_cj,
          height: 1.w_pt_cj,
        );
      },
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        if (index >= positionModels.length) {
          return moreItemWidget;
        }
        T positionInfo = positionModels[index];
        return LocationPoiCell<T>(
          onTap: () {
            chooseCompleteBack(positionInfo, null);
          },
          positionInfo: positionInfo,
        );
      },
    );
  }
}
