//
//  NSObject+JJ.m
//
//  Created by JeanKyle on 2015/1/4.
//  Copyright © 2015年 JeanKyle. All rights reserved.
//

#import "NSObject+JJ.h"

static inline NSString* kClip(Boolean isClip) {
    return isClip ? @"\"" : @"@\"";
}

//关联对象键值
static const void *objKey = &objKey;

@implementation NSObject (Associate)
/**
 根据键值获取关联对象

 @return 关联对象
 */
- (id)object {
    return objc_getAssociatedObject(self, objKey);
}
/**
 设置关联对象
 @param object 要设置的对象
 */
- (void)setObject:(id)object {
    //判断是否字符串选择拷贝对象或强引用对象，不使用线程原子锁
    objc_AssociationPolicy policy = [object isKindOfClass:[NSString class]] ? OBJC_ASSOCIATION_COPY_NONATOMIC : OBJC_ASSOCIATION_RETAIN_NONATOMIC;
    //关联对象
    objc_setAssociatedObject(self, objKey, object, policy);
}
@end

@implementation NSObject (JJ)

- (NSDictionary *)modelToDictionary {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    [self enumeratePropertiesUsingBlock:^(id obj, NSString *keyPath, NSUInteger idx, const char* attributes) {
        
        void (^block)() = ^{
            if (!isNull(obj)) [props setObject:obj forKey:keyPath];
        };
        class_getSubclassFromAttributes(attributes, ^(__unsafe_unretained Class cCls) {
            [props setValue:[obj modelToDictionary] forKey:keyPath];
        }, block, ^ {
            NSMutableArray *arrM = [NSMutableArray array];
            NSArray *objs = [self valueForKey:(NSString *)keyPath];
            
            [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isCustomObject]) {
                    [arrM addObject:[obj modelToDictionary]];
                }
            }];
            if (!isNull(arrM)) {
                [props setObject:arrM forKey:keyPath];
            }else {
                block();
            }
        }, block);
    }];
     return props;
}

- (BOOL)isCustomObject {
    return
    [self isKindOfClass:[NSObject class]] &&
    ![self isKindOfClass:[NSValue class]] &&
    ![self isKindOfClass:[NSString class]] &&
    ![self isKindOfClass:[NSArray class]] &&
    ![self isKindOfClass:[NSDictionary class]] &&
    ![self isKindOfClass:[NSSet class]];
}

- (NSString *)modelToJsonString {
    return [[self modelToDictionary] dictionaryToJsonString];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    return [dictionary dictionaryToModelByClass:self];
}
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary arrayObjectsClass:(NSArray<Class> *)arrayClass arrayKeyPath:(NSArray<NSString *> *)arrayKeyPath {
    return [dictionary dictionaryToModelByClass:self arrayObjectsClass:arrayClass arrayKeyPath:arrayKeyPath];
}

+ (NSArray *)arrayWithJsonArray:(id)jsonArray {
    return [jsonArray jsonsToModelsByClass:self];
}
+ (NSArray *)arrayWithJsonArray:(id)jsonArray cls:(Class)cls keyPath:(NSString *)keyPath {
    return [jsonArray jsonsToModelsByClass:self clss:cls keyPath:keyPath];
}
+ (NSArray *)arrayWithJsonArray:(id)jsonArray clss:(NSArray<Class> *)clss keyPaths:(NSArray<NSString *> *)keyPaths {
    return [jsonArray jsonsToModelsByClass:self clsArr:clss keyPaths:keyPaths];
}

+ (BOOL)objectIsNull:(id)obj {
    if (obj == nil) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return ((NSString *)obj).length == 0;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)obj;
        return arr.count == 0;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)obj;
        return dic.count == 0;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    return NO;
}


@end

@implementation NSObject (RT)

- (void)enumeratePropertiesUsingBlock:(void (^NS_NOESCAPE)(__kindof id obj, NSString *keyPath, NSUInteger idx, const char* attributes))block {
    u_int count, i;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    for (i = 0; i < count; i++) {
        objc_property_t p = list[i];
        
        const char* c = property_getName(p);
        NSString *pKey = [NSString stringWithUTF8String:c];
        
        const char* a = property_getAttributes(p);
        
         id pValue = [self valueForKey:(NSString *)pKey];
        if(!isNull(block)) block(pValue, pKey, i, a);
    }
    free(list);
}

- (void)enumerateIvarsUsingBlock:(void (^)(__kindof id obj, NSString *keyPath, NSUInteger idx, const char *typeEncoding))block {
    u_int count, i;
    Ivar *list = class_copyIvarList([self class], &count);
    for (i = 0; i < count; i++) {
        Ivar v = list[i];
        
        const char* c = ivar_getName(v);
        NSString *vKey = [NSString stringWithUTF8String:c];
        
        const char* a = ivar_getTypeEncoding(v);
        
        id vValue = [self valueForKey:(NSString *)vKey];
        if(!isNull(block)) block(vValue, vKey, i, a);
    }
    free(list);
}

@end

@implementation NSDictionary (JJ)


- (NSString *)dictionaryToJsonString {
    if (!isNull(self)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}


- (__kindof NSObject *)dictionaryToModelByClass:(Class)cls {
    
    return [self dictionaryToModelByClass:cls arrayObjectsClass:nil arrayKeyPath:nil];
}

- (__kindof NSObject *)dictionaryToModelByClass:(Class)cls arrayObjectsClass:(NSArray<Class> *)arrayClass arrayKeyPath:(NSArray<NSString *> *)arrayKeyPath {
    
    id model = [[cls alloc] init];
    
    [((NSObject *)model) enumeratePropertiesUsingBlock:^(__kindof id obj, NSString *keyPath, NSUInteger idx, const char *attributes) {
        id value = self[keyPath];
        void (^block)() = ^{
            if (!isNull(value)) [model setValue:value forKey:keyPath];
        };
        
        class_getSubclassFromAttributes(attributes, ^(__unsafe_unretained Class cCls) {
            
            [model setValue:[[cCls alloc] init] forKey:keyPath];
            if (!isNull(value)) {
                [model setValue:[((NSDictionary *)value) dictionaryToModelByClass:cCls] forKey:keyPath];
            }
        }, block, ^{
            if (arrayClass != nil && arrayClass.count && arrayKeyPath.count) {
                [arrayClass enumerateObjectsUsingBlock:^(Class oCls, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *arr = self[arrayKeyPath[idx]];
                    if (!isNull(arr)) {
                        NSArray *arrM = [arr jsonsToModelsByClass:oCls];
                        [model setValue:arrM forKey:arrayKeyPath[idx]];
                    }
                }];
            }else {
                block();
            }
        }, block);
    }];

    return model;
}

@end


@implementation NSArray (JJ)

- (BOOL)containsArray:(NSArray *)array {
    NSSet *origin = [NSSet setWithArray:self];
    NSSet *compare = [NSSet setWithArray:array];
    return [compare isSubsetOfSet:origin];
}

- (NSArray *)jsonsToModelsByClass:(Class)cls {
    
    NSMutableArray *arrM = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id dict, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj;
        if ([dict isKindOfClass:[NSDictionary class]]) {
            obj = [dict dictionaryToModelByClass:cls];
        } else {
            obj = dict;
        }
        [arrM addObject:obj];
    }];
    return arrM;
}

- (NSArray *)jsonsToModelsByClass:(Class)cls clss:(Class)clss keyPath:(NSString *)keyPath {
    
    NSMutableArray *arrM = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj = [dict dictionaryToModelByClass:cls arrayObjectsClass:@[clss] arrayKeyPath:@[keyPath]];
        [arrM addObject:obj];
    }];
    return arrM;
}

- (NSArray *)jsonsToModelsByClass:(Class)cls clsArr:(NSArray <Class>*)clsArr keyPaths:(NSArray <NSString *>*)keyPaths {
    NSMutableArray *arrM = [NSMutableArray array];
    [self enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        id obj = [dict dictionaryToModelByClass:cls arrayObjectsClass:clsArr arrayKeyPath:keyPaths];
        [arrM addObject:obj];
    }];
    return arrM;
}

@end


void class_getSubclassFromAttributes(const char *attributes, void(^customClass)(Class cCls), void(^systemClass)(), void(^array)(), void(^defaultType)()) {
    NSString *stringAttributes = [NSString stringWithUTF8String:attributes];
    if ([stringAttributes containsString:kClip(FALSE)]) {
        NSString *stringCls = [stringAttributes substringFromIndex:[stringAttributes rangeOfString:kClip(FALSE)].location + [stringAttributes rangeOfString:kClip(FALSE)].length];
        stringCls = [stringCls substringToIndex:[stringCls rangeOfString:kClip(TRUE)].location];
        Class cls = NSClassFromString(stringCls);
        id oc = [[cls alloc] init];
        if ([oc isKindOfClass:NSArray.class]){
            if (!isNull(array)) array();
        }else if ([oc isCustomObject]) {
            if (customClass) customClass(cls);
        }else {
            if(defaultType) defaultType();
        }
    }else {
        if(defaultType) defaultType();
    }
    
}
