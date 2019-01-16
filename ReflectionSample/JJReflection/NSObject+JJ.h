//
//  NSObject+JJ.h
//
//  Created by JeanKyle on 2015/1/4.
//  Copyright © 2015年 JeanKyle. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (Associate)

/**
 *  关联对象，黑科技带参，应用场景例如UIControl的派生类event传参时，尽量避免使用tag导致层级混乱或者值过少取到系统预留值
 */
@property (nonatomic) id object;

@end

@interface NSObject (JJ)
/* *
 *  @method 模型转字典
 *  @return 字典
 */
- (NSDictionary *)modelToDictionary;
/* *
 *  @method 是否自定义类
 *  @return YES/NO
 */
- (BOOL)isCustomObject;
/* *
 *  @method 模型转json字符串
 *  @return json字符串
 */
- (NSString *)modelToJsonString;
/**
 通过字典创建模型
 @param dictionary 字典数据
 @return 模型
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;
/**
 通过字典创建模型(包含模型数组)
 @param dictionary 字典数据
 @param arrayClass 字典包含模型数组，模型的class
 @param arrayKeyPath 字典包含模型数组，数组的keypath
 @return 模型
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary arrayObjectsClass:(NSArray <Class>*)arrayClass arrayKeyPath:(NSArray <NSString *>*)arrayKeyPath;
/**
 通过json数组创建模型数组(数组内模型不包含模型数组)
 @param jsonArray json数组
 @return 模型数组
 */
+ (NSArray *)arrayWithJsonArray:(id)jsonArray;
/**
 通过json数组创建模型数组(数组内模型包含一个模型数组)
 @param jsonArray json数组
 @param cls 数组内模型包含的模型数组的元素的class
 @param keyPath 数组内模型包含的模型数组的keypath
 @return 模型数组
 */
+ (NSArray *)arrayWithJsonArray:(id)jsonArray cls:(Class)cls keyPath:(NSString *)keyPath;
/**
  通过json数组创建模型数组(数组内模型包含多个模型数组)
 @param jsonArray json数组
 @param clss 数组内模型包含的各个模型数组的元素的class
 @param keyPaths 数组内模型包含的各个模型数组的keypath
 @warning clss和keyPaths的顺序必须一一对应
 @return 模型数组
 */
+ (NSArray *)arrayWithJsonArray:(id)jsonArray clss:(NSArray <Class>*)clss keyPaths:(NSArray <NSString *>*)keyPaths;

//+ (NSArray *)arrayWithJsonArray:(id)jsonArray NS_DEPRECATED_IOS(2_0, 7_0, "Use -jsonsToModelsByClass:") __TVOS_PROHIBITED;
//+ (NSArray *)arrayWithJsonArray:(id)jsonArray cls:(Class)cls keyPath:(NSString *)keyPath NS_DEPRECATED_IOS(2_0, 7_0, "Use -jsonsToModelsByClass:clss:keyPath:") __TVOS_PROHIBITED;
//+ (NSArray *)arrayWithJsonArray:(id)jsonArray clss:(NSArray <Class>*)clss keyPaths:(NSArray <NSString *>*)keyPaths NS_DEPRECATED_IOS(2_0, 7_0, "Use -jsonsToModelsByClass:clsArr:keyPaths:") __TVOS_PROHIBITED;

+ (BOOL)objectIsNull:(id)obj;
@end

static inline BOOL isNull(id obj) {
    return [NSObject objectIsNull:obj];
}

@interface NSObject (RT)
/**
 遍历模型属性
 @param block obj 属性   keyPath 属性名 idx序号 attributes 属性说明，不设break，谨慎使用
 */
- (void)enumeratePropertiesUsingBlock:(void(^)(__kindof id obj, NSString *keyPath, NSUInteger idx, const char* attributes))block;
/**
 遍历模型私有成员变量
 @param block obj 私有成员变量   keyPath 变量名 idx序号 typeEncoding 类型编码，不设break，谨慎使用
 */
- (void)enumerateIvarsUsingBlock:(void(^)(__kindof id obj, NSString *keyPath, NSUInteger idx, const char* typeEncoding))block;

@end


@interface NSDictionary (JJ)
/* *
 *  @method 字典转json字符串
 *  @return json字符串
 */
- (NSString *)dictionaryToJsonString;
/* *
 *  @method 字典转模型 (模型内部不包含模型数组)
 *  @param cls 模型类
 *  @return 模型
 *  @warning 字典键(key)数据与模型属性名必须一一对应，区分大小写
 */
- (__kindof NSObject *)dictionaryToModelByClass:(Class)cls;
/* *
 *  @method 字典转模型 (模型内部包含模型数组)
 *  @param cls 模型类
 *  @param arrayClass 模型内含模型数组，模型的class，如：@[[模型1 class], [模型2 class]]
 *  @param arrayKeyPath 模型内含模型数组，数组的keypath，如：@[@"模型数组1", @"模型数组2"]
 *  @return 模型
 *
 * 示例: TOrder *order = [orderJson dictionaryToModelByClass:[TOrder class] arrayObjectsClass:@[[TProduct class]] arrayKeyPath:@[@"products"]];
 * 表示TOrder内有TProduct数组 NSArray <TProduct>*products , 名字为products
 */
- (__kindof NSObject *)dictionaryToModelByClass:(Class)cls arrayObjectsClass:(NSArray <Class>*)arrayClass arrayKeyPath:(NSArray <NSString *>*)arrayKeyPath;

@end


@interface NSArray (JJ)
/**
 数组是否包含数组
 @param array 被包含的数组
 @return YES/NO
 */
- (BOOL)containsArray:(NSArray *)array;
/* *
 *  @method json数组转换成模型数组(模型内含一个或多个系统类数组均可使用此方法，如：NSArray<NSString *>*、NSArray<NSDictionary *>*)
 *  @param cls 模型class
 *  @return 模型数组
 */
- (NSArray *)jsonsToModelsByClass:(Class)cls;
/* *
 *  @method json数组转换成模型数组(模型含不超过1个数组<自定义模型数组>)
 *  @param cls 模型class
 *  @param clss 模型内含模型数组，该数组内模型class
 *  @param keyPath 模型内含模型数组，该数组keyPath
 *  @return 模型数组
 */
- (NSArray *)jsonsToModelsByClass:(Class)cls clss:(Class)clss keyPath:(NSString *)keyPath;
/* *
 *  @method json数组转换成模型数组(模型含超过1个数组<只要其中一个是自定义模型数组必须使用此方法，clsArr与KeyPath必须带上系统类数组>)
 *  @param cls 模型class
 *  @param clsArr 模型内含模型数组，该数组内模型class，如：@[[模型 class], [NSString class]]
 *  @param keyPaths 模型内含模型数组，该数组keyPath，如：@[@"模型数组", @"NSString数组"]
 *  @return 模型数组
 */
- (NSArray *)jsonsToModelsByClass:(Class)cls clsArr:(NSArray <Class>*)clsArr keyPaths:(NSArray <NSString *>*)keyPaths;

@end
/* *
 *  @method 根据属性说明从类中获取引用的类
 *  @param attributes 属性说明 property_getAttributes方法获取
 *  @param ^customClass 如果是自定义类，触发事件
 *  @param ^systemClass 如果是系统类，触发事件
 *  @param ^defaultType 如果是基本数据类型，触发事件
 */
void class_getSubclassFromAttributes(const char *attributes, void(^customClass)(Class cCls), void(^systemClass)(void), void(^array)(void), void(^defaultType)(void));

