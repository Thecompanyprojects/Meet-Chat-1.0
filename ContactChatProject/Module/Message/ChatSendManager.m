//
//  ChatSendManager.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ChatSendManager.h"
#import "SqliteManager.h"
#import "ChatManager.h"

@implementation ChatSendManager
+ (instancetype)sharedInstance{
    static ChatSendManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ChatSendManager alloc]init];
    });
    return _manager;
}
-(void)senderMessage:(CCMessageItem *)message withAfterSecond:(NSInteger)second{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        message.chatId = [[NSUUID UUID] UUIDString];
        NSString * sessionId = [NSString stringWithFormat:@"%@_%@",[CCUserModel sharedUserModel].userId,message.userId];
        [[SqliteManager sharedInstance] updateOneChatLogWithType:DBChatType_Private sessionID:sessionId aChatLog:message updateItems:nil complete:^(BOOL success, id obj) {
            NSLog(@"su---%d",success);
            NSLog(@"obj---%@",obj);
            if (success) {
                [self updateChatList:message];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageTab" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageDetail" object:nil userInfo:@{@"data":message}];
            }
        }];
    });
}
-(void)updateChatList:(CCMessageItem *)msgItem{
    NSString * sessionId = [NSString stringWithFormat:@"%@_list",[NSString stringWithFormat:@"%@",[CCUserModel sharedUserModel].userId]];
    msgItem.chatId = msgItem.userId;
    msgItem.createDate = [NSDate date].timeIntervalSince1970 * 1000;
    [[ChatManager sharedChatManager] cornerMark:msgItem.userId];
    [[SqliteManager sharedInstance] updateOneChatLogWithType:DBChatType_Private sessionID:sessionId aChatLog:msgItem updateItems:nil complete:^(BOOL success, id obj) {
        NSLog(@"su---%d",success);
        NSLog(@"obj---%@",obj);
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageListLoad" object:nil];
            });
        }
    }];
    [self updateRecieveCount:msgItem];
}
-(void)updateRecieveCount:(CCMessageItem *)msgItem{
    
    NSString * key = [NSString stringWithFormat:@"%@_recievecount",msgItem.userId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
        NSInteger count = [[[NSUserDefaults standardUserDefaults] objectForKey:key] integerValue];
        count ++;
        [[NSUserDefaults standardUserDefaults] setObject:@(count) forKey:key];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:key];
    }
    
}
@end
