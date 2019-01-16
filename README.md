# JJReflection
objective-c 通用反射机制，原本是自用的，花了些许时间解耦后分享给大家学习与交流，不足之处希望大神指正。

#### 使用方法很简单

```objective-c
#import <JJReflection.h>
//您的网络请求工具
[Http postUrl:url param:param completion:^(id response, NSError *error){
	//请求回来的模型，如果跟您建立的模型字段对应的话，可以直接转换
	if(!error) Model *model = [Model modelWithDictionary:response];
}];
//以上是基本用法，详细用法和注意事项可以下载Demo查看
```

#### 支持CocoaPods

```json
pod 'JJReflection'
```

