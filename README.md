# FeiShu-WeChat
红岩网校IOS期末大作业，仿写飞书加微信
## 1 简介
### 1.1 基本信息
- 仿写微信和飞书的部分功能
- language ：Objective-C
### 1.2 架构及框架
- 采用MVC设计模式
- 使用KeyChain进行登录密码的保存
- 使用FMDB对通讯录联系人数据进行保存
- 使用Masonry及YYText 进行文本和图片的布局
## 2 主要功能
### 2.1 登录
- 使用KeyChain对密码进行获取和保存
  
![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E7%99%BB%E5%BD%95.gif)
### 2.2 主界面
简单的UITableView，无法进入聊天页面，数据从plist文件获取

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E4%B8%BB%E7%95%8C%E9%9D%A2.gif)

### 2.3 通讯录
- UITableView,按联系人姓名首字母分组，顶部可根据联系人姓名进行查找并定位到对应的联系人Cell，右边有一个字母导航条.
- 外部联系人数据根据网络请求，利用FMDB保存本地缓存区，添加到通讯录的联系人利用FMDB从缓存区保存到数据区

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E9%80%9A%E8%AE%AF%E5%BD%95.gif)

### 2.4 朋友圈
#### 2.4.1主界面
- 原始数据来自plist文件
- 利用YYText实现图文混合
- 利用Masorny实现自适应Cell高度

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E6%9C%8B%E5%8F%8B%E5%9C%88.gif)
#### 2.4.2点赞
- 点击多功能按钮后有动态反馈，并刷新页面
- 数据保存到本地

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E7%82%B9%E8%B5%9E.gif)

#### 2.4.3评论
- 点击多功能按钮后弹出键盘和评论框
- 输入为空发布评论数据将无效
  
![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E8%AF%84%E8%AE%BA.gif)

#### 2.4.4发布
- 输入文本和选择图片，两者都为空时无法发布
- 图片最多仅能选择9张
- 数据采用plist文件保存到Document下，图片数据转化为NSData
  
![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E5%8F%91%E5%B8%83.gif)
#### 2.4.5删除
- 自己发布的朋友圈有删除选项，点击删除即可删除数据

### 2.5 点击头像
#### 2.5.1 更换头像

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E6%8D%A2%E5%A4%B4%E5%83%8F.gif)

#### 2.5.2 退出登录

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E9%80%80%E5%87%BA%E7%99%BB%E5%BD%95.gif)

## 3技术点和创新点
- 利用FMDB对联系人数据进行操作
- 朋友圈UI设计
  内容部分采用YYText将图片和文字结合到一起，并对图片进行一个裁剪或放缩以利于排版
  整条朋友圈通过设置Masonry实现了根据内容高度自适应
- 图片选择采用了PHPicker
- 联系人头像无需数据支持,而是在程序内部根据联系人姓名利用UIGraphics....()函数自动绘制出头像，模仿飞书的默认头像

![Alt text](https://github.com/Qingsong-Li/FeiShu-WeChat/blob/main/Images%20In%20ReadMe/%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F.jpg)


