//
//  CCMessageDetailController.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class CCMessageItem;

typedef void (^CloseBlock)(void);

@interface CCMessageDetailController : BaseViewController
@property (nonatomic, strong) CCMessageItem *msgItem;
@property(nonatomic,copy)CloseBlock closeBlock;
//@property(nonatomic,st)
@end

NS_ASSUME_NONNULL_END
