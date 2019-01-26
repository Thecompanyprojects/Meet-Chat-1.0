//
//  ChatSendManager.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCMessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatSendManager : NSObject
+ (instancetype)sharedInstance;
-(void)senderMessage:(CCMessageItem *)message withAfterSecond:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
