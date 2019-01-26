//
//  CCPersonModel.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCPersonModel.h"

@implementation CCPersonModel
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"Newid" : @"id"};
}
@end
