//
//  CCIsLodingManager.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCIsLodingManager : NSObject
+ (instancetype)sharedClient;
@property (nonatomic,assign) BOOL isTouch;
@end

NS_ASSUME_NONNULL_END
