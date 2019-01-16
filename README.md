# JJReflection
objective-c 通用反射机制，原本是自用的，花了些许时间解耦后分享给大家学习与交流，不足之处希望大神指正。

#### 使用方法很简单

`#import <JJReflection.h>`

`[Http postUrl:url param:param completion:^(id response, NSError *error){`

`	Model *model = [Model modelWithDictionary:response];`

`}];`