/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-02-06 11:19:41
 * @Description: 全局的游戏配置信息
 */
class GlobalGameConfigBean {
  late GameConfig turntableConfig;
  late GameConfig beanConfig;
  GameConfig? mineGameConfig;

  GlobalGameConfigBean({
    required this.turntableConfig,
    required this.beanConfig,
    this.mineGameConfig,
  });

  GlobalGameConfigBean.fromJson(Map<String, dynamic> json) {
    String turntableGameUrl;
    String turntableGameBackgroundImageUrl;
    if (json["turntable"] != null) {
      turntableGameUrl = json["turntable"]['url'] ?? '';
      turntableGameBackgroundImageUrl = json["turntable"]['bgImageUrl'] ?? '';
    } else {
      turntableGameUrl = json['turntableUrl'] ?? '';
      turntableGameBackgroundImageUrl = json['bgImageUrl'] ?? '';
    }
    json["turntableGame"] = {
      "gameName": "大转盘",
      // 'gameEntranceImage': {},
      "gameUrl": turntableGameUrl,
      "gameBackgroundImageUrl": turntableGameBackgroundImageUrl,
      "hideAppNavBar": true,
    };
    if (json["turntableGame"] != null) {
      turntableConfig = GameConfig.fromJson(json["turntableGame"]);
    }

    json["farmGame"] = {
      "gameName": json['beanBeanGame'] ?? '豆了个豆',
      // 'gameEntranceImage': {},
      "gameUrl": json['beanUrl'] ?? '',
      "hideAppNavBar": true,
    };
    if (json["farmGame"] != null) {
      beanConfig = GameConfig.fromJson(json["farmGame"]);
    }

    // json["gameInMine"] = {
    //   "gameName": "我的农场",
    //   // 'gameEntranceImage': {},
    //   // "gameUrl": 'http://dev-game.yuanwangwu.com/turntable/index.html',
    //   "gameUrl": "http://test-farm-game.yuanwangwu.com/index.html?time=239",
    //   "hideAppNavBar": true,
    // };
    if (json["gameInMine"] != null) {
      mineGameConfig = GameConfig.fromJson(json["gameInMine"]);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};

    if (mineGameConfig != null) {
      _data['gameInMine'] = mineGameConfig!.toJson();
    }

    return _data;
  }
}

// 游戏图片配置
class GameImageConfig {
  final String imageUrl;
  final double? imageWidth;
  final double? imageHeight;

  GameImageConfig({
    required this.imageUrl,
    this.imageWidth,
    this.imageHeight,
  });

  static GameImageConfig fromJson(Map<String, dynamic> json) {
    String imageUrl = json['imageUrl'] ?? '';
    double imageWidth = json['imageWidth'];
    double imageHeight = json['imageHeight'];

    return GameImageConfig(
      imageUrl: imageUrl,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (imageUrl != null) {
      _data['imageUrl'] = imageUrl;
    }
    if (imageWidth != null) {
      _data['imageWidth'] = imageWidth;
    }
    if (imageHeight != null) {
      _data['imageHeight'] = imageHeight;
    }

    return _data;
  }
}

class GameConfig {
  final bool show;
  final String? gameName; // 游戏名
  final GameImageConfig? gameEntranceImageBean; // 游戏入口图片
  final String gameUrl;
  final String? gameBackgroundImageUrl; // 游戏背景图(eg:大转盘需要)
  final bool shouldHideNavBar;

  GameConfig({
    this.show = true,
    this.gameName,
    this.gameEntranceImageBean,
    required this.gameUrl,
    this.gameBackgroundImageUrl,
    this.shouldHideNavBar = true,
  });

  static GameConfig fromJson(Map<String, dynamic> json) {
    String gameName = json['gameName'];
    GameImageConfig? gameEntranceImageBean;
    if (json['gameEntranceImage'] != null) {
      gameEntranceImageBean =
          GameImageConfig.fromJson(json['gameEntranceImage']);
    }
    String gameUrl = json['gameUrl'] ?? '';
    String gameBackgroundImageUrl = json['gameBackgroundImageUrl'];
    bool shouldHideNavBar = json["hideAppNavBar"] ?? true;

    return GameConfig(
      gameName: gameName,
      gameEntranceImageBean: gameEntranceImageBean,
      gameUrl: gameUrl,
      gameBackgroundImageUrl: gameBackgroundImageUrl,
      shouldHideNavBar: shouldHideNavBar,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (gameEntranceImageBean != null) {
      _data['gameEntranceImage'] = gameEntranceImageBean!.toJson();
    }
    if (gameUrl != null) {
      _data['gameUrl'] = gameUrl;
    }

    return _data;
  }
}
