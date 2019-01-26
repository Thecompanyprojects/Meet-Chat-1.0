//
//  CCVideolistModel.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCVideolistModel.h"

@implementation CCVideolistModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"Newid" : @"id"};
}
@end
