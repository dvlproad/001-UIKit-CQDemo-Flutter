/*
 * @Author: dvlproad
 * @Date: 2025-03-31 15:27:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-19 01:33:33
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_page.dart';
import 'l10n/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      locale: const Locale('en'),
      home: HomePage(),
    );
  }
}
