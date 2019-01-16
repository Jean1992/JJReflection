//
//  ModelNormal.h
//  ReflectionSample
//
//  Created by Jean on 2019/1/16.
//  Copyright © 2019 jean. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Gender) {
    GenderMale,
    GenderFemale
};

@interface Contact : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger mobile;
@end

@interface Skill : NSObject
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) double level;
@end

@interface ModelNormal : NSObject
@property (assign, nonatomic) NSInteger user_id;
@property (copy, nonatomic) NSString *user_nick;
@property (assign, nonatomic) Gender user_gender;
@property (strong, nonatomic) NSArray <NSString *>*user_tags;
@end

@interface ModelSales : NSObject
@property (assign, nonatomic) NSInteger user_id;
@property (copy, nonatomic) NSString *user_nick;
@property (assign, nonatomic) Gender user_gender;
@property (strong, nonatomic) NSArray <NSString *>*user_tags;
@property (strong, nonatomic) Contact *user_contact;
@property (strong, nonatomic) Skill *user_skill;

@end

@interface ModelGroup : NSObject
@property (assign, nonatomic) NSInteger group_id;
@property (assign, nonatomic) NSUInteger count;
@property (copy, nonatomic) NSString *group_name;
@property (strong, nonatomic) NSArray <ModelNormal *>*members;

@end

@interface ModelSet : NSObject
@property (assign, nonatomic) NSInteger group_id;
@property (assign, nonatomic) NSUInteger count;
@property (copy, nonatomic) NSString *group_name;
@property (strong, nonatomic) NSArray <ModelNormal *>*members;
@property (strong, nonatomic) NSArray <Contact *>*contacts;
@end
