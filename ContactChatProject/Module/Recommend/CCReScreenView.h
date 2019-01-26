//
//  CCReScreenView.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

@protocol ScreenDelegate <NSObject>

@optional
-(void)screeenPassDicValue:(id)data;
-(void)screenConfirm:(id)data;
@end

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCReScreenView : UIView
@property(nonatomic,assign)id delegate;
@end

NS_ASSUME_NONNULL_END
