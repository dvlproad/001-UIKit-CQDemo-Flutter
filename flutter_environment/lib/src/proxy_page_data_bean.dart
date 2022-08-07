/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 14:15:55
 * @Description: 代理的数据模型
 */
class TSEnvProxyModel {
  String proxyId;
  String name; // 网络代理的名称

  // 网络代理的 ip(设置值的时候，直接添加检验)
  String? _proxyIp;
  String? get proxyIp => _proxyIp;
  set proxyIp(String? testProxyIp) {
    bool canUpdate = CheckProxyUtil.canUpdateProxy(testProxyIp);
    if (canUpdate == false) {
      throw Exception(
          'Error:您设置的代理testProxyIp=$testProxyIp，既不是无代理，也不是有效的代理ip地址。(如果不设置代理,ip请设为null；如果要设置代理,ip请设置形如192.168.1.1)');
    }
    _proxyIp = testProxyIp;
  }

  String? useDirection; // 使用说明
  bool check; // 是否选中

  TSEnvProxyModel({
    required this.proxyId,
    required this.name,
    String? proxyIp,
    this.useDirection,
    this.check = false,
  }) {
    _proxyIp = proxyIp;
  }

  /// 没有使用代理
  static String noneProxykId = "proxyId_none";
  static String? noneProxykIp = null; // 只能设置为 null
  static TSEnvProxyModel noneProxyModel() {
    // 使用固定值，不能修改
    TSEnvProxyModel dataModel = TSEnvProxyModel(
      proxyId: TSEnvProxyModel.noneProxykId,
      name: "无代理",
      proxyIp: TSEnvProxyModel.noneProxykIp,
    );

    return dataModel;
  }

  // json 与 model 转换
  factory TSEnvProxyModel.fromJson(Map<String, dynamic> json) {
    return TSEnvProxyModel(
      proxyId: json['proxyId'],
      name: json['name'],
      proxyIp: json['proxyIp'],
      useDirection: json['useDirection'],
      check: json['check'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "proxyId": this.proxyId,
      "name": this.name,
      "proxyIp": this.proxyIp,
      "useDirection": this.useDirection,
      "check": this.check,
    };
  }
}

class CheckProxyUtil {
  // 判断是否能够更新代理（无代理 或 指定ip代理）
  static bool canUpdateProxy(String? ipString) {
    if (ipString == null) {
      return true; // 设置成”无代理“
    }

    bool isValid = isValidProxyIp(ipString); // 设置指定的代理ip地址
    if (isValid == false) {
      // print('Error:您设置的代理，既不是无代理，也不是有效的代理ip地址。(如果不设置代理,ip请设为null；如果要设置代理,ip请设置形如192.168.1.1)');
    }
    return isValid;
  }

  // 判断是否是有效的代理ip地址
  static bool isValidProxyIp(String ipString) {
    if (ipString == null) {
      return false;
    }

    final reg = RegExp(r'^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}');

    bool isMatch = reg.hasMatch(ipString);
    return isMatch;
  }
}
