//
//  CCMessageItem.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCMessageItem.h"
#import "NSObject+YHDBRuntime.h"


@implementation CCMessageItem
+ (NSString *)yh_primaryKey{
    return @"chatId";
}
@end
