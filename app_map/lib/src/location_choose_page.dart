import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
export 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFCoordinate;
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
export 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart'
    show BMFPoiInfo;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wish/common/colors.dart';

import 'dart:async';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:wish/common/locate_manager.dart';
import 'package:wish/widget/appbar_view.dart';

import 'package:tim_ui_kit_lbs_plugin/widget/location_input.dart';

//39.965, 116.404北京
class LocationChoosePage extends StatefulWidget {
  final Function(BMFPoiInfo? entity) callBack;

  LocationChoosePage({
    Key? key,
    required this.callBack,
  }) : super(key: key);

  @override
  _LocationChoosePageState createState() => _LocationChoosePageState();
}

class _LocationChoosePageState extends State<LocationChoosePage> {
  TextEditingController inputKeywordEditingController = TextEditingController();

  /// 用户经纬度
  double _userLatitude = 39.965;
  double _userLongitude = 116.404;

  /// 移动经纬度
  double _moveLatitude = 39.965;
  double _moveLongitude = 116.404;

  bool _isLocateSuccess = false;

  List<BMFPoiInfo> _poiInfoList = [];

  // 构造检索参数
  List<String> _keywords = [
    "办公楼",
    "小区",
    '餐饮',
    '酒店',
    "学校",
    "超市",
    "医院",
    "公交",
    '景点'
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    BMFMapSDK.setAgreePrivacy(true);
    //开始定位
    LocateManager.instance.startLocation((LocateModel model) {
      _userLatitude = model.latitude;
      _userLongitude = model.longitude;
      // _stopLocation();
      _isLocateSuccess = true;
      _moveLatitude = model.latitude;
      _moveLongitude = model.longitude;
      _searchNearby(latitude: _moveLatitude, longitude: _moveLongitude);
    });
  }

  /// 检索指定位置的附近
  void _searchNearby({
    double? latitude,
    double? longitude,
  }) async {
    // 构造检索参数
    BMFPoiNearbySearchOption poiNearbySearchOption = BMFPoiNearbySearchOption(
      keywords: _keywords,
      location: BMFCoordinate(latitude ?? 0.0, longitude ?? 0.0),
      radius: 500,
      isRadiusLimit: true,
      pageIndex: 0,
      pageSize: 20,
      scope: BMFPoiSearchScopeType.DETAIL_INFORMATION,
    );
    // 检索实例
    BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
    // 检索回调
    nearbySearch.onGetPoiNearbySearchResult(
        callback: (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
      print(
          'poi周边检索回调 errorCode = ${errorCode}  \n result = ${result.toMap()}');
      setState(() {
        _poiInfoList = result.poiInfoList != null ? result.poiInfoList! : [];
      });
    });
    // 发起检索
    bool flag = await nearbySearch.poiNearbySearch(poiNearbySearchOption);
  }

  /// 检索指定城市里的
  void _searchInCity({
    String? city,
    required String keyword,
  }) async {
    BMFPoiCitySearchOption poiCitySearchOption =
        BMFPoiCitySearchOption(city: city ?? '厦门', keyword: keyword);
    // 检索实例
    BMFPoiCitySearch poiCitySearch = BMFPoiCitySearch();
    // 检索回调
    poiCitySearch.onGetPoiCitySearchResult(
        callback: (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
      print(
          'poi城市检索回调 errorCode = ${errorCode}  \n result = ${result.toMap()}');
      // 解析reslut，具体参考demo
      setState(() {
        _poiInfoList = result.poiInfoList != null ? result.poiInfoList! : [];
      });
    });
    // 发起检索
    bool flag = await poiCitySearch.poiCitySearch(poiCitySearchOption);
    if (!flag) {
      print("检索指定城市里的poi失败");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    _renderMap(mapHeight: 400.h),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: _renderContent(mapHeight: 400.h),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _renderContent({required double mapHeight}) {
    double top = MediaQueryData.fromWindow(window).padding.top;
    return Container(
      height: MediaQuery.of(context).size.height - top - 44 - mapHeight,
      // constraints: BoxConstraints(
      //   maxHeight: MediaQuery.of(context).size.height / 10 * 3,
      //   maxWidth: MediaQuery.of(context).size.width,
      // ),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            // color: Colors.red,
            height: 50.h,
            child: LocationInput(
              onChange: (String keyword) {
                // debouncePOICitySearch(keyword);
                _searchInCity(keyword: keyword);
              },
              controller: inputKeywordEditingController,
            ),
          ),
          _renderItemNoChoose(context, height: 30.h),
          Expanded(child: _listWidget(context)),
          // Container(
          //   // constraints: BoxConstraints(
          //   //   maxHeight: MediaQuery.of(context).size.height / 10 * 3,
          //   //   maxWidth: MediaQuery.of(context).size.width,
          //   // ),
          //   height: MediaQuery.of(context).size.height / 2,
          //   // padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
          //   decoration: const BoxDecoration(
          //     color: Colors.red,
          //   ),
          //   child: Expanded(child: _listWidget(context)),
          // )
        ],
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
      title: GestureDetector(
        onTap: () {
          // FocusScope.of(context).requestFocus(FocusNode());
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Text(
          "定位",
          style: TextStyle(
            color: color_222222,
            fontSize: 15.w,
          ),
        ),
      ),
      backgroundColor: Color(0xFFEDF1F5),
      elevation: 0,
      brightness: Brightness.dark,
    );
  }

  _renderMap({required double mapHeight}) {
    if (_isLocateSuccess == false) {
      return Container(height: mapHeight);
    }
    return Container(
      height: mapHeight,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            left: 0.w,
            top: 0.w,
            height: mapHeight,
            width: MediaQuery.of(context).size.width,
            child: _mapWidget(context),
          ),
          Positioned(
            top: (mapHeight - 30.w - 30.w) / 2,
            height: 30.w,
            width: 30.w,
            child: Container(
              // color:Colors.yellow,
              child: Image(
                image:
                    AssetImage('images/mine/BaiduMap/icon_binding_point.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapWidget(BuildContext context) {
    BMFCoordinate center = BMFCoordinate(_userLatitude, _userLongitude);
    BMFMapOptions mapOptions = BMFMapOptions(
      mapType: BMFMapType.Standard,
      zoomLevel: 17,
      maxZoomLevel: 21,
      minZoomLevel: 4,
      logoPosition: BMFLogoPosition.LeftBottom,
      mapPadding: BMFEdgeInsets(top: 0, left: 0, right: 0, bottom: 0),
      overlookEnabled: true,
      overlooking: 0,
      center: center,
    );

    BMFMapController myMapController;
    return BMFMapWidget(
      onBMFMapCreated: (controller) {
        myMapController = controller;
        myMapController.showUserLocation(true);
        BMFCoordinate coordinate = BMFCoordinate(_userLatitude, _userLongitude);

        BMFLocation location = BMFLocation(
            coordinate: coordinate,
            altitude: 0,
            horizontalAccuracy: 5,
            verticalAccuracy: -1.0,
            speed: -1.0,
            course: -1.0);
        BMFUserLocation userLocation = BMFUserLocation(
          location: location,
        );
        // myMapController.updateLocationData(userLocation);
        myMapController.updateLocationData(userLocation).then((e) {
          print("e:${e}");
        });

        // BMFUserlocationDisplayParam displayParam = BMFUserlocationDisplayParam(
        //     locationViewOffsetX: 0,
        //     locationViewOffsetY: 0,
        //     accuracyCircleFillColor: Colors.red,
        //     accuracyCircleStrokeColor: Colors.blue,
        //     isAccuracyCircleShow: true,
        //     locationViewImage: 'resoures/animation_red.png',
        //     locationViewHierarchy:
        //     BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);

        // myMapController.updateLocationViewWithParam(displayParam);

        // /// 地图加载回调
        myMapController.setMapDidLoadCallback(callback: () {
          print("setMapDidLoadCallback");

          // /// 创建BMFMarker
          // BMFMarker marker = BMFMarker(
          //   position:
          //       BMFCoordinate(_userLatitude, _userLongitude),
          //   title: 'flutterMaker',
          //   identifier: 'flutter_marker',
          //   icon: 'images/mine/BaiduMap/icon_binding_point.png',
          //   isLockedToScreen: true,
          //   screenPointToLock: BMFPoint(
          //       MediaQuery.of(context).size.width / 2, 300.w / 2),
          //   canShowCallout: false,
          // );
          //
          // /// 添加Marker
          // myMapController.addMarker(marker);
        });

        /// 地图区域改变完成后会调用此接口
        /// mapStatus 地图状态信息
        /// regionChangeReason 地图改变原因
        myMapController.setMapRegionDidChangeWithReasonCallback(callback:
            (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
          if (mapStatus.targetGeoPt == null) {
            _moveLatitude = 0.0;
            _moveLongitude = 0.0;
          } else {
            BMFCoordinate targetGeoPt = mapStatus.targetGeoPt!;
            _moveLatitude = targetGeoPt.latitude;
            _moveLongitude = targetGeoPt.longitude;
          }

          print("${_moveLatitude}");
          print("${_moveLongitude}");
          _searchNearby(latitude: _moveLatitude, longitude: _moveLongitude);
          inputKeywordEditingController.text = '';
          // _searchInCity(keyword: '学校');
        });
      },
      mapOptions: mapOptions,
    );
  }

  Widget _listWidget(BuildContext context) {
    return ListView.separated(
      itemCount: _poiInfoList.length,
      itemBuilder: (BuildContext context, int index) {
        BMFPoiInfo poiInfo = _poiInfoList[index];
        return _renderItem(context, poiInfo: poiInfo);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.grey,
          indent: 15.w,
          endIndent: 15.w,
          height: 1.w,
        );
      },
    );
  }

  _renderItemNoChoose(
    BuildContext context, {
    required double height,
  }) {
    if (_isLocateSuccess == false) {
      return Container();
    }
    return InkWell(
      splashColor: Colors.grey,
      onTap: () {
        Navigator.of(context).pop();
        if (widget.callBack != null) {
          widget.callBack(null);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        // color: Colors.green,
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Center(
                  child: Text(
                    '不显示定位',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0xFF6A87AC),
                      fontSize: 14.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _renderItem(BuildContext context, {BMFPoiInfo? poiInfo}) {
    double latitude = 0.0;
    double longitude = 0.0;
    if (poiInfo != null && poiInfo.pt != null) {
      latitude = poiInfo.pt!.latitude;
      longitude = poiInfo.pt!.longitude;
    }

    return InkWell(
      splashColor: Colors.grey,
      onTap: () {
        // if (latitude == 0 || longitude == 0) {
        //   ToastUtil.showMessage('当前经纬度为{$latitude,$longitude},请换个');
        //   return;
        // }
        Navigator.of(context).pop();
        if (widget.callBack != null) {
          widget.callBack(poiInfo);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.w),
            Text(
              poiInfo?.name ?? '',
              style: TextStyle(color: Colors.black, fontSize: 14.w),
            ),
            SizedBox(height: 5.w),
            Text(
              poiInfo?.address ?? '',
              style: TextStyle(color: Colors.grey, fontSize: 12.w),
            ),
            SizedBox(height: 5.w),
          ],
        ),
      ),
    );
  }
}
