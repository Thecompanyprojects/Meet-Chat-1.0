//
//  CCbottleAlertView.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^replyBlock)(NSString *string);

@interface CCbottleAlertView : UIView

@property(nonatomic,copy)replyBlock replyClick;
-(void)withrepylClick:(replyBlock)block;
@property (nonatomic,strong) UITextView *messageText;
@property (nonatomic,strong) UIImageView *coverImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *ageLab;
@property (nonatomic,strong) UIImageView *sexImg;
@property (nonatomic,strong) UILabel *contentLab;

@end

NS_ASSUME_NONNULL_END
