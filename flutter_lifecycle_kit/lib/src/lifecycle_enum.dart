/*
 * @Author: dvlproad
 * @Date: 2022-05-12 17:34:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-12-18 16:56:05
 * @Description: 生命周期的 枚举
 */
enum AppearBecause {
  newCreate, // 新显示
  pop, // 从其他界面pop回来的
  resume, // 从后台进入前台
  monitor, // 监控页面元素所得
}

enum DisAppearBecause {
  goNew, // 去新的页面
  pop, // 退出当前界面
  pause, // 从前台进入后台
  monitor, // 监控页面元素所得
  inactive // 应用失活
}
