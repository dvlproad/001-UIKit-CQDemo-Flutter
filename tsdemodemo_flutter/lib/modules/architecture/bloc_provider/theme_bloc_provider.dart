import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bloc.dart';

class ThemeBlocProvider extends InheritedWidget {
  final ThemeBloc bLoC = ThemeBloc();

  ThemeBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ThemeBloc of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<ThemeBlocProvider>()
              as ThemeBlocProvider)
          .bLoC;
  // static ThemeBloc of(BuildContext context) =>
  //     (context.dependOnInheritedWidgetOfExactType(ThemeBlocProvider) as ThemeBlocProvider).bLoC.
}
