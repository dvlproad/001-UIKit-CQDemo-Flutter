import 'package:flutter/material.dart';
import 'package:ez_localization/ez_localization.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LangUtil {
  static String l(String key, {List<String> args}) {
    return EzLocalization.of(navigatorKey.currentContext).get(key, args) ?? key;
  }

  static String localizedString(String key, BuildContext context,
      {List<String> args}) {
    return EzLocalization.of(context).get(key, args) ?? key;
  }
}
