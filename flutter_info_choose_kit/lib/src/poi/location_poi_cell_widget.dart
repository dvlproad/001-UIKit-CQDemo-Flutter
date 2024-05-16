/*
 * @Author: dvlproad
 * @Date: 2024-01-26 15:29:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-11 18:42:59
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_base_models/flutter_base_models.dart';

import '../../flutter_info_choose_kit_adapt.dart';

class LocationPoiCell<T extends NearbyAddressModel> extends StatelessWidget {
  final T positionInfo;
  final void Function() onTap;

  const LocationPoiCell({
    Key? key,
    required this.positionInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 15.w_pt_cj, right: 15.w_pt_cj),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.w_pt_cj),
            Text(
              positionInfo.name,
              style: TextStyle(color: Colors.black, fontSize: 14.w_pt_cj),
            ),
            SizedBox(height: 5.w_pt_cj),
            Text(
              positionInfo.address,
              style: TextStyle(color: Colors.grey, fontSize: 12.w_pt_cj),
            ),
            SizedBox(height: 5.w_pt_cj),
          ],
        ),
      ),
    );
  }
}
