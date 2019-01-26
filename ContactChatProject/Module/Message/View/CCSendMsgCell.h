//
//  CCSendMsgCell.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCSendMsgCell : UITableViewCell
@property(nonatomic,assign)id<CellPassDelegate> delegate;
@property(nonatomic,strong)NSIndexPath * indexPath;
- (void)setContentMsg:(CCMessageItem *)msgItem;
@property(nonatomic,strong)CCMessageItem * msgItem;
@end

NS_ASSUME_NONNULL_END
