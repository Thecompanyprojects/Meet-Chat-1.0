//
//  ChatManager.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "ChatManager.h"
#import "SqliteManager.h"

@implementation ChatManager
+ (instancetype)sharedChatManager{
    static ChatManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ChatManager alloc]init];
    });
    return _manager;
}
-(void)chatSayHi:(NSString *)userId withContent:(NSString *)content withUserName:(NSString *)userName withPhoto:(NSString *)photo{
    CCMessageItem * item = [[CCMessageItem alloc]init];
    item.userId = userId;
    item.chatId = item.userId;
    item.userName = userName;
    item.message = content;
    item.photo = photo;
    item.createDate = (long long)[NSDate date].timeIntervalSince1970 * 1000;
    item.sendUserId = [CCUserModel sharedUserModel].userId;
    NSString * sessionId = [NSString stringWithFormat:@"%@_list",[CCUserModel sharedUserModel].userId];
    [[SqliteManager sharedInstance] updateOneChatLogWithType:DBChatType_Private sessionID:sessionId aChatLog:item updateItems:nil complete:^(BOOL success, id obj) {
        NSLog(@"su---%d",success);
        NSLog(@"obj---%@",obj);
    }];
    
    item.userId = [CCUserModel sharedUserModel].userId;
    //消息详情数据库更新
    NSString * sessionId1 = [NSString stringWithFormat:@"%@_%@",[CCUserModel sharedUserModel].userId,userId];
    [[SqliteManager sharedInstance] updateOneChatLogWithType:DBChatType_Private sessionID:sessionId1 aChatLog:item updateItems:nil complete:^(BOOL success, id obj) {
        NSLog(@"su---%d",success);
        NSLog(@"obj---%@",obj);
        
    }];
}
-(void)cornerMark:(NSString *)chatId{
    NSDictionary * cornerMarList =  [[NSUserDefaults standardUserDefaults] objectForKey:@"cornerMarList"];
    if (cornerMarList) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:cornerMarList];
        if ([cornerMarList objectForKey:chatId]) {
            NSInteger count = [[cornerMarList objectForKey:chatId] integerValue];
            [dict setObject:@(count + 1) forKey:chatId];
        }else{
            [dict setObject:@(1) forKey:chatId];
        }
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"cornerMarList"];
    }else{
        NSDictionary * dict = @{chatId:@(1)};
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"cornerMarList"];
    }
}
-(void)cornerMarkZero:(NSString *)userId{
    if (userId) {
        NSDictionary * cornerMarList =  [[NSUserDefaults standardUserDefaults] objectForKey:@"cornerMarList"];
        if (cornerMarList) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:cornerMarList];
            [dict setObject:@(0) forKey:userId];
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"cornerMarList"];
        }else{
            NSDictionary * dict = @{userId:@0};
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"cornerMarList"];
        }
    }
}
@end
