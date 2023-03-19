/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-16 17:20:23
 * @Description: 
 */
import 'package:flutter/material.dart';

enum JurisdictionType {
  all, //所有人可见
  self, //我自己可见
  partSee, //部分人可见
  partNoSee, //部分人不可见
}

class JurisdictionBean {
  // final JurisdictionType type;
  final String text;

  JurisdictionBean({
    // required this.type,
    @required this.text,
  });
}
