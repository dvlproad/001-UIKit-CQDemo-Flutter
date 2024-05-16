// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_base_models/flutter_base_models.dart';

import '../../flutter_info_choose_kit_adapt.dart';

class AreaPicker<T extends BaseCityModel<T>> extends StatefulWidget {
  final Color color;
  final double height;
  final Color selectedBackgroundColor;
  final Color normalTextColor;
  final Color okTitleColor;

  final bool shouldAddAllProvinceItem;
  final bool shouldAddAllCityItem;
  final bool shouldAddAllAreaItem;

  final Future<List<T>> Function() cityModelsGetHandle;
  final AreaPickerSelectedIndexsModel? selectModel;

  final void Function(AreaPickerAddressModel areaPickerAddressModel)
      onConfirmHandle;

  const AreaPicker({
    Key? key,
    this.color = Colors.white,
    required this.height,
    this.selectedBackgroundColor = const Color(0x20FF4587),
    this.normalTextColor = const Color(0xFF222222),
    this.okTitleColor = const Color(0xFFE67D4F),
    this.shouldAddAllProvinceItem = false,
    required this.shouldAddAllCityItem,
    required this.shouldAddAllAreaItem,
    this.selectModel,
    required this.cityModelsGetHandle,
    required this.onConfirmHandle,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AreaPickerState<T>();
}

class AreaPickerState<T extends BaseCityModel<T>> extends State<AreaPicker<T>> {
  List<T> provinceModels = [];
  List<T> cityModels = [];
  List<T> districtModels = [];

  ///选中的省份的index
  int selectedProvinceIndex = 0;

  ///选中的市的index
  int selectedCityIndex = 0;

  ///选中的区的index
  int selectedDistrictIndex = 0;

  // 定义省份控制器
  late FixedExtentScrollController proviceCotroller;
  // 定义市控制器
  late FixedExtentScrollController cityController;
  // 定义区控制器
  late FixedExtentScrollController districtController;

  late AreaPickerSelectedIndexsModel _selectModel;

  @override
  void initState() {
    super.initState();

    _selectModel = widget.selectModel ??
        AreaPickerSelectedIndexsModel(
          provinceIndex: 0,
          cityIndex: 0,
          districtIndex: 0,
        );
    proviceCotroller = FixedExtentScrollController(
      initialItem: _selectModel.provinceIndex ?? 0,
    );
    cityController = FixedExtentScrollController(
      initialItem: _selectModel.cityIndex ?? 0,
    );
    districtController = FixedExtentScrollController(
      initialItem: _selectModel.districtIndex ?? 0,
    );

    widget.cityModelsGetHandle().then((List<T> value) {
      if (value.isEmpty) {
        return;
      }
      provinceModels = value;

      selectedProvinceIndex = max(0, _selectModel.provinceIndex ?? 0);
      selectedCityIndex = max(0, _selectModel.cityIndex ?? 0);
      selectedDistrictIndex = max(0, _selectModel.districtIndex ?? 0);

      cityModels = provinceModels[selectedProvinceIndex].children ?? [];
      selectedCityIndex = min(selectedCityIndex, cityModels.length - 1);
      districtModels = cityModels[selectedCityIndex].children ?? [];

      passParams();
    });
  }

  /// 用来提供给外部更新 AreaPickerState areaPickerState = areaPickerKey.currentState!;
  jumpTo(AreaPickerSelectedIndexsModel selectModel) {
    _selectModel = selectModel;

    proviceCotroller.cj_jumpToItem(selectModel.provinceIndex).whenComplete(() {
      cityController.cj_jumpToItem(selectModel.cityIndex).whenComplete(() {
        districtController.cj_jumpToItem(selectModel.districtIndex);
      });
    });
  }

  makeControllersToIndexs(
      List<FixedExtentScrollController> controller, List<int> indexs) async {
    for (int i = 0; i < controller.length; i++) {
      await controller[i].cj_jumpToItem(indexs[i]);
    }
  }

  ///给父组件传递结果
  AreaPickerAddressModel? _areaPickerAddressModel;
  void passParams() {
    setState(() {
      if (provinceModels.isEmpty) {
        return;
      }
      _areaPickerAddressModel = AreaPickerAddressModel.fromSelectedIndex<T>(
        provinceModels: provinceModels,
        cityModels: cityModels,
        districtModels: districtModels,
        shouldAddAllProvinceItem: widget.shouldAddAllProvinceItem,
        shouldAddAllCityItem: widget.shouldAddAllCityItem,
        shouldAddAllAreaItem: widget.shouldAddAllAreaItem,
        proviceIndex: selectedProvinceIndex,
        cityIndex: selectedCityIndex,
        districtIndex: selectedDistrictIndex,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      height: widget.height,
      padding: EdgeInsets.only(
        left: 15.w_pt_cj,
        right: 15.w_pt_cj,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _renderToolbar(context),
          if (provinceModels.isNotEmpty)
            Expanded(
              child: Container(
                // color: Colors.amber,
                height: widget.height - toolbarHeight,
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _renderProvince()),
                    Expanded(flex: 1, child: _renderCityPickerItem()),
                    Expanded(flex: 1, child: _renderAreaPickerItem()),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  CupertinoPicker _renderProvince() {
    return _renderPickerItem(
      shouldAddAllItem: widget.shouldAddAllProvinceItem,
      categoryIndex: 0,
      data: provinceModels,
      scrollController: proviceCotroller,
      onSelectedItemChanged: (position) {
        setState(() {
          selectedProvinceIndex = position;
          int citysParentIndex;
          if (widget.shouldAddAllProvinceItem) {
            citysParentIndex =
                selectedProvinceIndex > 0 ? selectedProvinceIndex - 1 : 0;
          } else {
            citysParentIndex = selectedProvinceIndex;
          }
          cityModels = provinceModels[citysParentIndex].children ?? [];

          selectedCityIndex = 0;
          int districtsParentIndex;
          if (widget.shouldAddAllCityItem) {
            districtsParentIndex =
                selectedCityIndex > 0 ? selectedCityIndex - 1 : 0;
          } else {
            districtsParentIndex = selectedCityIndex;
          }
          districtModels = cityModels[districtsParentIndex].children ?? [];
        });
        cityController.jumpToItem(0);
        districtController.jumpToItem(0);
        passParams();
      },
    );
  }

  CupertinoPicker _renderCityPickerItem() {
    return _renderPickerItem(
      shouldAddAllItem: widget.shouldAddAllCityItem,
      categoryIndex: 1,
      data: cityModels,
      scrollController: cityController,
      onSelectedItemChanged: (position) {
        setState(() {
          selectedCityIndex = position;
          selectedDistrictIndex = 0;

          int districtsParentIndex;
          if (widget.shouldAddAllCityItem) {
            districtsParentIndex =
                selectedCityIndex > 0 ? selectedCityIndex - 1 : 0;
          } else {
            districtsParentIndex = selectedCityIndex;
          }
          districtModels = cityModels[districtsParentIndex].children ?? [];
        });
        districtController.jumpToItem(0);
        passParams();
      },
    );
  }

  CupertinoPicker _renderAreaPickerItem() {
    return _renderPickerItem(
      shouldAddAllItem: widget.shouldAddAllAreaItem,
      categoryIndex: 2,
      data: districtModels,
      scrollController: districtController,
      onSelectedItemChanged: (int index) {
        selectedDistrictIndex = index;
        passParams();
      },
    );
  }

  CupertinoPicker _renderPickerItem({
    required bool shouldAddAllItem,
    required List<T> data,
    required int categoryIndex,
    required FixedExtentScrollController scrollController,
    required void Function(int index) onSelectedItemChanged,
  }) {
    List<Widget> itemWidgets = [];
    if (shouldAddAllItem == true) {
      itemWidgets.add(_renderItemWidget("全部"));
    }

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      itemWidgets.add(_renderItemWidget(item.regionName));
    }

    BorderRadius borderRadius = BorderRadius.circular(0.h_pt_cj);
    if (categoryIndex == 0) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10.h_pt_cj),
        bottomLeft: Radius.circular(10.h_pt_cj),
      );
    } else if (categoryIndex == 2) {
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(10.h_pt_cj),
        bottomRight: Radius.circular(10.h_pt_cj),
      );
    } else {
      borderRadius = BorderRadius.circular(0.h_pt_cj);
    }

    return CupertinoPicker(
      backgroundColor: Colors.transparent,
      scrollController: scrollController,
      itemExtent: 45.h_pt_cj,
      selectionOverlay: Container(
        height: 40.w_pt_cj,
        decoration: BoxDecoration(
          color: widget.selectedBackgroundColor,
          borderRadius: borderRadius,
        ),
      ),
      onSelectedItemChanged: (int index) {
        onSelectedItemChanged(index);
      },
      children: itemWidgets,
    );
  }

  double toolbarHeight = 50.h_pt_cj;
  Container _renderToolbar(BuildContext context) {
    return Container(
      color: Colors.white,
      height: toolbarHeight,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              '取消',
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: widget.normalTextColor,
                fontSize: 15.w_pt_cj,
              ),
            ),
          ),
          Expanded(
            child: Center(
                child: Text(
              "选择地区",
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.bold,
                color: widget.normalTextColor,
                fontSize: 15.w_pt_cj,
              ),
            )),
          ),
          GestureDetector(
            onTap: () {
              if (_areaPickerAddressModel == null) {
                return;
              }
              debugPrint("您选择的地址是:${_areaPickerAddressModel!.address}");
              widget.onConfirmHandle(_areaPickerAddressModel!);
              Navigator.pop(context);
            },
            child: Text(
              '确认',
              style: TextStyle(
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: widget.okTitleColor,
                fontSize: 15.w_pt_cj,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> createEachProvinceItem(List<T> data) {
    List<Widget> target = [];
    for (T item in data) {
      target.add(_renderItemWidget(item.regionName));
    }

    return target;
  }

  List<Widget> createEachCityItem(List<T?> data) {
    List<Widget> target = [];

    for (T? item in data) {
      target.add(_renderItemWidget(item!.regionName));
    }
    return target;
  }

  List<Widget> createEachDistrictItem(bool showAllAreaType, List<T?> data) {
    List<Widget> target = [];
    if (showAllAreaType == true) {
      target.add(_renderItemWidget("全部"));
    }

    for (int i = 0; i < data.length; i++) {
      final item = data[i]!;
      target.add(_renderItemWidget(item.regionName));
    }

    return target;
  }

  _renderItemWidget(String text) {
    return Center(
      // padding: EdgeInsets.only(top: 10.w_pt_cj, bottom: 10.w_pt_cj),
      child: AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: 10,
        textAlign: TextAlign.center,
        // overflow: TextOverflow.fade,
        style: TextStyle(
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
          fontSize: 14.w_pt_cj,
          color: widget.normalTextColor,
        ),
      ),
    );
  }
}

extension PickerExtension on FixedExtentScrollController {
  Future<void> cj_jumpToItem(int? itemIndex) {
    return animateToItem(
      itemIndex ?? 0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
