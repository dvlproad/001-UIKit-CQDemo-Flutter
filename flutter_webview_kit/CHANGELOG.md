## [0.0.1] - 2019-04-03

* webView

## [0.0.2] - 2019-04-04

* 增加 app_call_h5 的 js channel

## [0.0.3] - 2019-04-10

* 添加 user-agent 方法，并完善其他js方法

## [0.0.4] - 2019-04-11

* 添加 cjjs_getUserLocationInfo : 获取用户当前位置信息

## [0.0.5] - 2019-04-12

* 添加 cjjs_share : 分享(TEXT文本、IMAGE图片地址、VIDEO视频地址、WEBPAGE网页链接)到微信
  
## [0.0.6] - 2019-04-13

* 去除不应属于底层的冗余js，精简化底层。修复 JSResponseModel.success code错误问题

## [0.0.8] - 2019-04-13

* 添加遗漏的 cjjs_closeWebView 方法

## [0.0.9] - 2019-04-15

* 增加js运行到不存在的方法的时候也会提示，由外部过滤是否去掉提示；添加 platformDescriptionGetBlock 方法，告知ui边距来源的平台； 添加 h5 数据的持久化方法；并整理统一h5参数转为h5Params的方法

