//
//  CCEditorViewController.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/11.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BaseViewController.h"
#import "CCPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnTextBlock)(NSString *showText);

@interface CCEditorViewController : BaseViewController
@property (nonatomic,strong) CCPersonModel *personModel;
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end

NS_ASSUME_NONNULL_END
