# JJReflection
objective-c 通用反射机制，原本是自用的，花了些许时间解耦后分享给大家学习与交流，不足之处希望大神指正。

#### 使用方法很简单

```objective-c
#import "JJReflection.h"
//您的网络请求工具
[Http postUrl:url param:param completion:^(id response, NSError *error){
	//请求回来的模型，如果跟您建立的模型字段对应的话，可以直接转换
	if(!error) Model *model = [Model modelWithDictionary:response];
}];
//以上是基本用法，详细用法和注意事项可以下载Demo查看
```

```json
//可以是简单模型
{
    "name": "LiLei",
    "age": 15,
    "likes": ["篮球", "吉他"],
    "contact_info": {
    	"name": "李磊",
        "gender": 0,
        "mobile": 18814150001
    }
}
```

```json
//也可以是复杂模型
{
    "user_id": 105,
    "user_name": "JEAN908218375",
    "user_skills": [
        {
            "skill_name": "英雄联盟",
            "level": 138
        },
        {
            "skill_name": "唱歌",
            "level": 99
        }
    ],
    "user_info": {
        "gender": 0,
        "icon": "https://www.jean.com/icon.png",
        "u_flag": 6,
        "create_time": "2013-05-17"
    },
    "experience": [
        {
            "unit": "Jean小学",
            "begin_date": "xxxx-xx-xx",
            "end_date": "xxxx-xx-xx",
            "remarks": "荣获奥数全省第一名"
        },
        {
            "unit": "Jean中学",
            "begin_date": "xxxx-xx-xx",
            "end_date": "xxxx-xx-xx",
            "remarks": "荣获初三期中考试全级第一名"
        },
        {
            "unit": "Jean高中",
            "begin_date": "xxxx-xx-xx",
            "end_date": "xxxx-xx-xx",
            "remarks": "啥也没"
        },
        {
            "unit": "Jean大学",
            "begin_date": "xxxx-xx-xx",
            "end_date": "xxxx-xx-xx",
            "remarks": "吹牛逼第一名"
        }
    ]
}
```

