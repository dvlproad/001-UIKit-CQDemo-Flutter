/*
 * @Author: dvlproad
 * @Date: 2024-05-08 17:24:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-15 10:21:28
 * @Description: 
 */
import 'package:flutter/material.dart';

import './base_choose_item_model.dart';

import '../../flutter_info_choose_kit_adapt.dart';

class BaseChooseItemView<T extends BaseChooseItemModel>
    extends StatelessWidget {
  final double height;
  final T item;
  final bool isSelected;

  const BaseChooseItemView({
    Key? key,
    required this.height,
    required this.item,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(8.w_pt_cj),
            border: isSelected
                ? Border.all(
                    color: const Color(0xFF333333),
                    width: 2.h_pt_cj,
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            item.name,
            style: TextStyle(
              fontFamily: 'PingFang SC',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
              fontSize: 14.f_pt_cj,
              color: isSelected
                  ? const Color(0xFF333333)
                  : const Color(0xFF666666),
            ),
          ),
        ),
        Visibility(
          visible: isSelected,
          child: Positioned(
            right: 0,
            top: 0,
            child: _checkIcon(),
          ),
        ),
      ],
    );
  }

  Widget _checkIcon() {
    double imageWith = 24;
    return GestureDetector(
      onTap: () {
        // onPressedDelete(imageIndex);
      },
      child: Container(
        // color: Colors.red,
        width: imageWith + 0,
        height: imageWith + 0,
        child: Center(
          child: Image(
            image: const AssetImage(
              'assets/icon_check.png',
              package: 'flutter_info_choose_kit',
            ),
            width: imageWith,
            height: imageWith,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
