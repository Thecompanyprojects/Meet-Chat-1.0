//
//  CCmessageModel.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCmessageModel.h"

@interface CCmessageModel()
@property (nonatomic,strong) NSMutableArray *messageArray;
@end

@implementation CCmessageModel

+ (instancetype)sharedClient {
    static CCmessageModel *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CCmessageModel alloc] init];
    });
    return _sharedClient;
}

-(NSMutableArray *)messageArray
{
    if(!_messageArray)
    {
        _messageArray = [NSMutableArray array];
        [_messageArray addObject:@"How are you doing?"];
        [_messageArray addObject:@"Hi. Long time no see."];
        [_messageArray addObject:@"Today is a great day."];
        [_messageArray addObject:@"Have a nice weekend."];
        [_messageArray addObject:@"Nice talking to you."];
        [_messageArray addObject:@"Sorry to bother you."];
        [_messageArray addObject:@"I like it a lot."];
        [_messageArray addObject:@"That’s very nice of you."];
        [_messageArray addObject:@"I like your style."];
        [_messageArray addObject:@"How do I look?"];
        [_messageArray addObject:@"You look great!"];
        [_messageArray addObject:@"Are you married or single?"];
        [_messageArray addObject:@"I’ve been dying to see you."];
        [_messageArray addObject:@"I’m crazy about you."];
        [_messageArray addObject:@"love you with all my heart."];
        [_messageArray addObject:@"You’re everything to me."];
        [_messageArray addObject:@"Do you have a partner?"];
        [_messageArray addObject:@"What do you think about me?"];
        [_messageArray addObject:@"You're the most beautiful woman I've ever seen."];
        [_messageArray addObject:@"It was love at first sight."];
        [_messageArray addObject:@"I’m happy to have known you."];
    }
    return _messageArray;
}

-(NSString *)showbackmessage
{
    NSString *str = [NSString new];
    int i = arc4random() % self.messageArray.count;
    str = [self.messageArray objectAtIndex:i];
    return str;
}

@end
