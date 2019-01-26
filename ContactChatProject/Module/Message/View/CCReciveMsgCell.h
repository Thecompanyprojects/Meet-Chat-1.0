//
//  CCReciveMsgCell.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCReciveMsgCell : UITableViewCell
@property (weak,nonatomic)IBOutlet UIImageView * vipView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property(nonatomic,assign)id<CellPassDelegate> delegate;
@property(nonatomic,strong)NSIndexPath * indexPath;
@property(nonatomic,assign)NSInteger receiveCount;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,assign)BOOL isVisable;
- (void)setContentMsg:(CCMessageItem *)msgItem;
- (void)setHeadImg:(NSString *)imgUrlStr;
@end

NS_ASSUME_NONNULL_END
