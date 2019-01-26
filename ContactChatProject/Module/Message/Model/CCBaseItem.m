//
//  CCBaseItem.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCBaseItem.h"

@implementation CCBaseItem
- (instancetype)initWithItem:(id)item {
    return [[self class] mj_objectWithKeyValues:item];
}
@end
