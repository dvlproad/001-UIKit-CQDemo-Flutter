import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_home_page.dart';

import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page0.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page3.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page4.dart';

import 'package:tsdemodemo_flutter/modules/architecture/0setState/theme_result_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_result_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc/theme_result_page3.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_result_page4.dart';
import 'package:tsdemodemo_flutter/modules/architecture/redux/theme_result_page5.dart';

class ArcRouters {
  // 设计模式的测试首页
  static const architectureHomePage = '/architecture_home_page';

  static const arc0SetStatePage = '/architecture_0setState_page';
  static const arcProviderUsePage0 = '/architecture_ProviderUse_page0';
  static const arcProviderUsePage1 = '/architecture_ProviderUse_page1';
  static const arcProviderUsePage2 = '/architecture_ProviderUse_page2';
  static const arcProviderUsePage3 = '/architecture_ProviderUse_page3';
  static const arcProviderUsePage4 = '/architecture_ProviderUse_page4';

  static const arc1ProviderPage = '/architecture_1Provider_page';
  static const arc1ProviderSharePage = '/architecture_1ProviderShare_page';
  static const arc2BlockPage = '/architecture_2Block_page';
  static const arc2BlockProviderPage = '/architecture_2BlockProvider_page';
  static const arc3ReduxPage = '/architecture_3Redux_page';

  static Map<String, WidgetBuilder> routes = {
    // 设计模式 architecture
    ArcRouters.architectureHomePage: (BuildContext context) => TSArcHomePage(),
    ArcRouters.arcProviderUsePage0: (BuildContext context) =>
        ProviderUsePage0(),
    ArcRouters.arcProviderUsePage1: (BuildContext context) =>
        ProviderUsePage1(),
    ArcRouters.arcProviderUsePage2: (BuildContext context) =>
        ProviderUsePage2(),
    ArcRouters.arcProviderUsePage3: (BuildContext context) =>
        ProviderUsePage3(),
    ArcRouters.arcProviderUsePage4: (BuildContext context) =>
        ProviderUsePage4(),
    ArcRouters.arc0SetStatePage: (BuildContext context) => ThemeResultPage1(),
    ArcRouters.arc1ProviderPage: (BuildContext context) => ThemeResultPage2(),
    // ArcRouters.arc1ProviderSharePage: (BuildContext context) => ThemeResultPage2(),
    ArcRouters.arc2BlockPage: (BuildContext context) => ThemeResultPage3(),
    ArcRouters.arc2BlockProviderPage: (BuildContext context) =>
        ThemeResultPage4(),
    ArcRouters.arc3ReduxPage: (BuildContext context) => ThemeResultPage5(),
  };
}
