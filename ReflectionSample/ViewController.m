//
//  ViewController.m
//  ReflectionSample
//
//  Created by Jean on 2019/1/16.
//  Copyright © 2019 jean. All rights reserved.
//

#import "ViewController.h"
#import "JJReflection.h"
#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//#warning Options 此处可选下列方法查看打印值或断点调试
//    [self jsonToModelNormal];
//    [self jsonToModelContainsModel];
//    [self jsonToModelContainsModels];
//    [self jsonsToArrayNormal];
//    [self jsonsToArrayContainsModelsSingle];
    [self jsonsToArrayContainsModels];
}

#pragma mark - json转模型(模型内仅含OC常用类或者基本数据类型，或常用类与基本数据类型的数组)
- (void)jsonToModelNormal {
    NSDictionary *json = @{
                           @"user_id": @(328),
                           @"user_nick": @"行走的CD",
                           @"user_gender": @(0),
                           @"user_tags": @[@"天籁", @"情歌", @"男神"]
                           };
    ModelNormal *model = [ModelNormal modelWithDictionary:json];
//两种创建方法二选其一    model = [json dictionaryToModelByClass:[ModelNormal class]];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", model.user_tags.firstObject);
}

#pragma mark - json转模型(模型内含自定义模型)
- (void)jsonToModelContainsModel {
    NSDictionary *json = @{
                           @"user_id": @(328),
                           @"user_nick": @"行走的CD",
                           @"user_gender": @(0),
                           @"user_tags": @[@"天籁", @"情歌", @"男神"],
                           @"user_contact": @{
                                   @"name": @"林俊杰",
                                   @"mobile": @(18888888888)
                                   },
                           @"user_skill": @{
                                   @"name": @"唱歌",
                                   @"level": @(9.9)
                                   }
                           };
    ModelSales *model = [ModelSales modelWithDictionary:json];
//两种创建方法二选其一    model = [json dictionaryToModelByClass:[ModelSales class]];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", model.user_contact.name);
}

#pragma mark - json转模型(模型内包含自定义模型的数组)
- (void)jsonToModelContainsModels {
    NSDictionary *json = @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           };
    ModelGroup *group = [ModelGroup modelWithDictionary:json arrayObjectsClass:@[[ModelNormal class]] arrayKeyPath:@[@"members"]];
//两种创建方法二选其一    group = [json dictionaryToModelByClass:ModelGroup.self arrayObjectsClass:@[ModelGroup.self] arrayKeyPath:@[@"members"]];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", group.members.firstObject.user_nick);
}

#pragma mark - json数组转模型数组(模型内不包含模型数组)
- (void)jsonsToArrayNormal {
    NSArray *jsons = @[
                       @{
                           @"user_id": @(16),
                           @"user_nick": @"第一人",
                           @"user_gender": @(0),
                           @"user_tags": @[@"很好", @"不错", @"nice"]
                           },
                       @{
                           @"user_id": @(17),
                           @"user_nick": @"第二人",
                           @"user_gender": @(0),
                           @"user_tags": @[@"还行", @"不赖", @"凑合"]
                           },
                       @{
                           @"user_id": @(18),
                           @"user_nick": @"第三人",
                           @"user_gender": @(1),
                           @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                           },
                       @{
                           @"user_id": @(19),
                           @"user_nick": @"第四人",
                           @"user_gender": @(0),
                           @"user_tags": @[@"蓝瘦", @"香菇"]
                           }
                       ];
    NSArray <ModelNormal *>*models = [jsons jsonsToModelsByClass:ModelNormal.self];
//两种创建方法二选其一    models = [ModelNormal arrayWithJsonArray:jsons];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", models.firstObject.user_nick);
}

#pragma mark - json数组转模型数组(模型内包含一个模型数组)
- (void)jsonsToArrayContainsModelsSingle {
    NSArray *jsons = @[
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           },
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           },
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           }
                       ];
    NSArray <ModelGroup *>*models = [jsons jsonsToModelsByClass:ModelGroup.self clss:ModelNormal.self keyPath:@"members"];
//两种创建方法二选其一    models = [ModelGroup arrayWithJsonArray:jsons cls:ModelNormal.self keyPath:@"members"];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", models.firstObject.group_name);
}

#pragma mark - json数组转模型数组(模型内包含多个模型数组)
- (void)jsonsToArrayContainsModels {
    NSArray *jsons = @[
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"contacts": @[
                                   @{
                                       @"name": @"第一人",
                                       @"mobile": @(18888888888)
                                       },
                                   @{
                                       @"name": @"第二人",
                                       @"mobile": @(18888888887)
                                       },
                                   @{
                                       @"name": @"第三人",
                                       @"mobile": @(18888888886)
                                       },
                                   @{
                                       @"name": @"第四人",
                                       @"mobile": @(18888888885)
                                       }
                                   ],
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           },
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"contacts": @[
                                   @{
                                       @"name": @"第一人",
                                       @"mobile": @(18888888888)
                                       },
                                   @{
                                       @"name": @"第二人",
                                       @"mobile": @(18888888887)
                                       },
                                   @{
                                       @"name": @"第三人",
                                       @"mobile": @(18888888886)
                                       },
                                   @{
                                       @"name": @"第四人",
                                       @"mobile": @(18888888885)
                                       }
                                   ],
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           },
                       @{
                           @"group_id": @(2447),
                           @"group_name": @"群聊",
                           @"count": @(4),
                           @"contacts": @[
                                   @{
                                       @"name": @"第一人",
                                       @"mobile": @(18888888888)
                                       },
                                   @{
                                       @"name": @"第二人",
                                       @"mobile": @(18888888887)
                                       },
                                   @{
                                       @"name": @"第三人",
                                       @"mobile": @(18888888886)
                                       },
                                   @{
                                       @"name": @"第四人",
                                       @"mobile": @(18888888885)
                                       }
                                   ],
                           @"members": @[
                                   @{
                                       @"user_id": @(16),
                                       @"user_nick": @"第一人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"很好", @"不错", @"nice"]
                                       },
                                   @{
                                       @"user_id": @(17),
                                       @"user_nick": @"第二人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"还行", @"不赖", @"凑合"]
                                       },
                                   @{
                                       @"user_id": @(18),
                                       @"user_nick": @"第三人",
                                       @"user_gender": @(1),
                                       @"user_tags": @[@"不好", @"郁闷", @"很灰"]
                                       },
                                   @{
                                       @"user_id": @(19),
                                       @"user_nick": @"第四人",
                                       @"user_gender": @(0),
                                       @"user_tags": @[@"蓝瘦", @"香菇"]
                                       }
                                   ]
                           }
                       ];
    NSArray <ModelSet *>*models = [jsons jsonsToModelsByClass:ModelSet.self clsArr:@[ModelNormal.self, Contact.self] keyPaths:@[@"members", @"contacts"]];
//两种创建方法二选其一    models = [ModelSet arrayWithJsonArray:jsons clss:@[ModelNormal.self, Contact.self] keyPaths:@[@"members", @"contacts"]];
//#warning Breakpoint 此处可打断点查看模型属性
    NSLog(@"%@", models.firstObject.group_name);
}

@end
