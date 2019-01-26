//
//  ChatManager.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatManager : NSObject
+ (instancetype)sharedChatManager;
-(void)chatSayHi:(NSString *)userId withContent:(NSString *)content withUserName:(NSString *)userName withPhoto:(NSString *)photo;

-(void)cornerMarkZero:(NSString *)userId;
-(void)cornerMark:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
