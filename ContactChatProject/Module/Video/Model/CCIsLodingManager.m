//
//  CCIsLodingManager.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCIsLodingManager.h"

@implementation CCIsLodingManager
+ (instancetype)sharedClient {
    static CCIsLodingManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CCIsLodingManager alloc] init];
        
    });
    return _sharedClient;
}
@end
