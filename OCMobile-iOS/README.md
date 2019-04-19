# OpenCart iOS 商城客户端

## OpenCart 版本兼容
- OpenCart v2.3.x
- OpenCart v3.0.x

此商城项目使用 Objective-C 开发，实现了商品分类、商品列表、商品详情、购物车、结账支付、个人中心、搜索等功能 。接口对接定制的 OpenCart Lumen API。首页和商品详情使用嵌入 HTML5 页面。首页内容可在 Web 管理后台配置。

## 让项目先跑起来
### 编译前准备
项目编译前，请提前准备好以下第三方平台需要使用的资料
- 微信支付/登录
- 支付宝支付
- Paypal 支付
- QQ 登录
- 微博登录
- 极光推送
- ShareSDK 账号

另外请确保 API 接口服务器已经部署并能正常运行。

### Pod 安装
此项目使用了若干第三方开源库，需要使用 CocoaPods 安装。安装方法请参考：[https://cocoapods.org/](https://cocoapods.org)，然后运行以下命令安装第三方类库：

> pod install

### 配置 .pch 文件及编译
1. 最新编译 xcode 版本：`v10.2 (10E125)`
2. xcode 中打开 `Supporting Files -> PrefixHeader.pch`，修改其中配置。如 OC 网站地址、 API 接口地址、Paypal、微信支付、JPush、ShareSDK 相关账号
3. 进入 `Project Settings` 修改 `Bundle Identifier` 和配置 `Provisioning Profile`
4. 以上配置好后即可开始编译调试了

## 项目说明
### 第三方登录
第三方登录使用的是 ShareSDK：[http://www.mob.com/](http://www.mob.com/)。支持以下几种登录方式：

- 微信
- QQ
- 微博

### 支付方式
- 微信
- 支付宝
- Paypal

### 消息推送 - Push Notification
消息推送使用极光推送（JPush）：[https://www.jiguang.cn/](https://www.jiguang.cn/)，支持推送的内容有：
- URL 链接：可在 webview 中打开
- 商品：打开商品详情
- 分类：打开分类的商品列表

### 分享功能
分享功能是指在商品详情页面右上角的分享功能，同样使用的是 ShareSDK：http://www.mob.com/

## 第三方类库 CocoaPods
项目中用到了以下几种第三方类库：
- AFNetworking：网络请求
- SDWebImage：图片加载
- MBProgressHUD：HUD 加载提示框
- Masonry：Auto Layout 库
- JSONModel：JSON 数据转 Model
