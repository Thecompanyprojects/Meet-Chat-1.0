//
//  CCEditoralertView.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/11.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^replyBlock)(NSString *string);

@interface CCEditoralertView : UIView

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UITextField *editorText;
@property(nonatomic,copy)replyBlock replyClick;
-(void)withrepylClick:(replyBlock)block;
@property (nonatomic,copy) NSString *typeStr;

@end

NS_ASSUME_NONNULL_END
