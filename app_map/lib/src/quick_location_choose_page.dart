import 'dart:core';
import 'package:flutter/material.dart';
import 'package:tim_ui_kit_lbs_plugin/abstract/map_class.dart';
import 'package:tim_ui_kit_lbs_plugin/abstract/map_widget.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/color.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/location_utils.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/tim_location_model.dart';
import 'package:tim_ui_kit_lbs_plugin/utils/utils.dart';
import 'package:tim_ui_kit_lbs_plugin/widget/location_input.dart';
import 'package:tim_ui_kit_lbs_plugin/widget/location_list_item.dart';

import 'package:tim_ui_kit_lbs_plugin/i18n/i18n_utils.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/widget/appbar_view.dart';

class QuickLocationPicker extends StatefulWidget {
  /// The onChange(LocationMessage) callback after users finish choosing the location.
  /// 【Reminder】As the location message of Tencent Cloud IM only includes one string, 'desc', so the 'LocationMessage.desc' here splicing the name and address into a string.
  /// Such as: "The University of Sydney/////Camperdown NSW 2006".
  /// The splicing format can be parsed by anywhere in this plug-in.
  /// 地理位置选择完成后的onChange事件，返回一个LocationMessage，可用于发送消息。
  /// 特别说明：由于腾讯云IM位置消息仅支持传递一个desc字符串，因此此处的LocationMessage.desc将名称及地址拼接传递，格式："腾讯大厦/////深圳市南山区深南大道10000号"。
  /// 该拼接格式可被本插件所需地方解析，请放心使用。
  final ValueChanged<LocationMessage> onChange;
  final Function() onClear;

  /// LocationUtils with the TIMMapService implemented with specific Map SDK.
  /// 传入根据选定地图SDK实例化后的LocationUtils
  final LocationUtils locationUtils;

  /// The default center coordinate shows before positioning.
  /// 用于还未加载出来定位时，打开页面后，默认的中心点。
  final TIMCoordinate? initCoordinate;

  /// To control if the poisoning ability from Map SDK is needed, if true, please make sure 'moveToCurrentLocationActionWithSearchPOIByMapSDK' been implemented correctly.
  /// 用于控制是否使用地图SDK定位能力。若使用，请确保moveToCurrentLocationActionWithSearchPOIByMapSDK方法继承正确。
  final bool? isUseMapSDKLocation;

  /// TIMMapWidget with the inherited map widget by the Map SDK you chose.
  /// 传入根据选定地图SDK实例化后的地图组件TIMMapWidget
  final TIMMapWidget Function(
      VoidCallback onMapLoadDone,
      Key mapKey,
      Function(TIMCoordinate? targetGeoPt,
              TIMRegionChangeReason regionChangeReason)
          onMapMoveEnd) mapBuilder;

  const QuickLocationPicker(
      {Key? key,
      required this.onChange,
      required this.onClear,
      required this.mapBuilder,
      required this.locationUtils,
      this.initCoordinate,
      this.isUseMapSDKLocation = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => QuickLocationPickerState();
}

class QuickLocationPickerState extends State<QuickLocationPicker> {
  GlobalKey<TIMMapState> mapKey = GlobalKey();
  List<TIMPoiInfo> poiInfoList = [];
  String currentSearchCity = "深圳市"; // "Shenzhen City"
  TIMCoordinate? currentCoordinate;
  String currentSelectedPOI = "";
  String currentLocationName = "";
  TextEditingController inputKeywordEditingController = TextEditingController();
  String dividerForDesc = "/////";

  @override
  void initState() {
    super.initState();
  }

  void _onGetPoiCitySearchResult(
      List<TIMPoiInfo>? poiInfoListResult, bool isError) {
    final I18nUtils ttBuild = I18nUtils(context);
    if (isError) {
      var error = ttBuild.imt("检索失败"); // "search failed"
      Utils.toast(error);
      return;
    }

    if (poiInfoListResult != null && poiInfoListResult.isNotEmpty) {
      TIMPoiInfo firstPOI = poiInfoListResult[0];
      mapKey.currentState?.moveMapCenter(firstPOI.pt!);
      setState(() {
        currentSearchCity = firstPOI.city ?? "深圳市"; // "Shenzhen City"
        currentCoordinate =
            TIMCoordinate(firstPOI.pt!.latitude, firstPOI.pt!.longitude);
        currentSelectedPOI = firstPOI.uid!;
        currentLocationName =
            "${firstPOI.name}$dividerForDesc${firstPOI.address}";
      });
    }

    setState(() {
      poiInfoList = poiInfoListResult ?? [];
    });
  }

  void _onGetReverseGeoCodeSearchResult(
      TIMReverseGeoCodeSearchResult result, bool isError) {
    final I18nUtils ttBuild = I18nUtils(context);
    if (isError) {
      var error = ttBuild.imt("检索失败"); // "search failed"
      Utils.toast(error);
      return;
    }
    inputKeywordEditingController.text = "";
    List<TIMPoiInfo> poiInfoListWithCurrent = [
      // Add the current POI to the list first place as the default POI
      // 将实时定位点补入POI列表第一项作为默认位置
      TIMPoiInfo(
        name: result.semanticDescription,
        pt: result.location,
        uid: "0312",
        address: result.address,
        city: result.addressDetail?.city ?? "深圳市", // "Shenzhen City"
      ),
      ...?result.poiList
    ];
    setState(() {
      poiInfoList = poiInfoListWithCurrent;
      currentSearchCity =
          result.addressDetail?.city ?? "深圳市"; // "Shenzhen City"
      currentCoordinate = result.location;
      currentSelectedPOI = "0312";
      currentLocationName =
          "${result.semanticDescription}$dividerForDesc${result.address}";
    });
  }

  List<Widget> renderPOIList() {
    return poiInfoList.map((item) {
      return LocationLstItem(
        name: item.name ?? "",
        isSelected: item.uid == currentSelectedPOI,
        address: item.address,
        onClick: () {
          setState(() {
            currentSelectedPOI = item.uid!;
            currentSearchCity = item.city ?? currentSearchCity;
            currentCoordinate = item.pt;
            currentLocationName = "${item.name}$dividerForDesc${item.address}";

            _onSendMsg();
          });
          mapKey.currentState?.moveMapCenter(item.pt!);
        },
      );
    }).toList();
  }

  void _onSendMsg() {
    if (currentLocationName.isNotEmpty && currentCoordinate != null) {
      LocationMessage locationMessage = LocationMessage(
        desc: currentLocationName,
        longitude: currentCoordinate!.longitude,
        latitude: currentCoordinate!.latitude,
      );
      widget.onChange(locationMessage);
      Navigator.pop(context);
    } else {
      print("Please choose a location first");
    }
  }

  Future<void> moveToCurrentLocation() async {
    if (widget.isUseMapSDKLocation != null &&
        widget.isUseMapSDKLocation == true) {
      widget.locationUtils.moveToCurrentLocationActionWithSearchPOI(
        onGetReverseGeoCodeSearchResult: _onGetReverseGeoCodeSearchResult,
        moveMapCenter: mapKey.currentState!.moveMapCenter,
      );
    } else {
      final TIMCoordinate? currentLocation = await widget.locationUtils
          .moveToCurrentLocationActionWithoutSearchPOI(
              moveMapCenter: mapKey.currentState!.moveMapCenter);

      if (currentLocation != null) {
        widget.locationUtils.searchPOIByCoordinate(
            coordinate: currentLocation,
            onGetReverseGeoCodeSearchResult: _onGetReverseGeoCodeSearchResult);
      }
    }
  }

  void onMapLoadDone() {
    if (widget.initCoordinate != null) {
      mapKey.currentState!.moveMapCenter(widget.initCoordinate!);
    }
    moveToCurrentLocation();
  }

  void onMapMoveEnd(
      TIMCoordinate? targetGeoPt, TIMRegionChangeReason regionChangeReason) {
    // If users drag the map manually, re-search the center coordinate
    // 如果是手动拖动地图到了新位置，将中心点的坐标重新搜索
    if (targetGeoPt != null &&
        regionChangeReason == TIMRegionChangeReason.Gesture) {
      widget.locationUtils.searchPOIByCoordinate(
          coordinate: targetGeoPt,
          onGetReverseGeoCodeSearchResult: _onGetReverseGeoCodeSearchResult);
      inputKeywordEditingController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final I18nUtils ttBuild = I18nUtils(context);
    final debouncePOICitySearch = LocationUtils.debounce((keyword) {
      widget.locationUtils.poiCitySearch(
          onGetPoiCitySearchResult: _onGetPoiCitySearchResult,
          keyword: keyword,
          city: currentSearchCity);
    });
    return Scaffold(
      appBar: _renderAppBar(),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    widget.mapBuilder(
                      onMapLoadDone,
                      mapKey,
                      onMapMoveEnd,
                    ),
                    // 地图中心点位置
                    Positioned(
                        child: Container(
                      margin: const EdgeInsets.only(bottom: 22),
                      child: const Icon(
                        Icons.place,
                        color: CommonColor.primaryColor,
                        size: 44,
                      ),
                    )),
                    // 我的位置
                    Positioned(
                      right: 16,
                      bottom: 26,
                      child: GestureDetector(
                        onTap: moveToCurrentLocation,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                spreadRadius: 0.4,
                                color: CommonColor.weakTextColor, //阴影颜色
                              ),
                            ],
                          ),
                          child: const SizedBox(
                            child: Icon(
                              Icons.my_location,
                              color: CommonColor.primaryColor,
                              size: 24,
                            ),
                            height: 44,
                            width: 44,
                          ),
                        ),
                      ),
                    ),
                    /*
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            minHeight: 100),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black38,
                              Colors.black38,
                              Color.fromRGBO(0, 0, 0, 0),
                            ],
                            stops: [0, 0.67, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 52,
                      left: 28,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          ttBuild.imt("取消"), // "cancel"
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 48,
                        right: 28,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                CommonColor.primaryColor),
                          ),
                          onPressed: _onSendMsg,
                          child: Text(ttBuild.imt("完成")), // "send"
                        )),
                    */
                  ],
                ),
              ),
              LocationInput(
                onChange: (String keyword) {
                  debouncePOICitySearch(keyword);
                },
                controller: inputKeywordEditingController,
              ),
              _renderItemNoChoose(context),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 10 * 3,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: renderPOIList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _renderAppBar() {
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          width: 50.w,
          height: 44.w,
          alignment: Alignment.center,
          child: getBackWidget(context),
        ),
      ),
      title: Text(
        "定位",
        style: TextStyle(
          color: Color(0xFF222222),
          fontSize: 15,
        ),
      ),
      backgroundColor: Color(0xFFEDF1F5),
      elevation: 0,
      brightness: Brightness.dark,
    );
  }

  _renderItemNoChoose(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap: () {
        // Navigator.of(context).pop();
        // if (widget.callBack != null) {
        //   widget.callBack(null);
        // }

        widget.onClear();
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '不显示定位',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color(0xFF6A87AC),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
