//
//  CCMessageCell.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCMessageCell : UITableViewCell
//@property(nonatomic,strong)MessageItem * item;
- (void)setMessageContent:(CCMessageItem *)item;
@end

NS_ASSUME_NONNULL_END
