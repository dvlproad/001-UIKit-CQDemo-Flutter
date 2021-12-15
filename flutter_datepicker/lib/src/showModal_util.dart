import 'package:flutter/material.dart';

class ShowModalUtil {
  static Future<T> showInBottom<T>({
    @required BuildContext context,
    @required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    showModalBottomSheet(
      context: context, //state.context,
      isScrollControlled: isScrollControlled,
      // backgroundColor: Colors.black,
      builder: builder,
    );
  }
}
