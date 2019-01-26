//
//  MyImageView.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

-(void)addTarget:(id)target action:(SEL)action{
    _target = target;
    _action = action;
    self.userInteractionEnabled = YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
    if (touch.view == self) {
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
    }
    
    
}

@end
