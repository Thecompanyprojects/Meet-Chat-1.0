//
//  CCUserModel.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCUserModel.h"

@implementation CCUserModel
+ (instancetype)sharedUserModel{
    static CCUserModel *_userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userModel = [[CCUserModel alloc]init];
    });
    return _userModel;
}

@end
