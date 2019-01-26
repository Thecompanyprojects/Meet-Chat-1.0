//
//  MyImageView.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyImageView : UIImageView
{
    id _target;
    SEL _action;
}
-(void)addTarget:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
