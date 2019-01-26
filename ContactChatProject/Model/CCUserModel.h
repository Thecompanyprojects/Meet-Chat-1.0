//
//  CCUserModel.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCUserModel : NSObject
+ (instancetype)sharedUserModel;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSString * token;
@property(nonatomic,copy)NSString * refreshtoken;
@property(nonatomic,copy)NSString * userId;
@property(nonatomic,copy)NSArray *  userphotos;

@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * single;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * horoscope;

@end

NS_ASSUME_NONNULL_END
