//
//  CCVideoCell.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCVideolistModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(UICollectionViewCell *)cell;

@end

@interface CCVideoCell : UICollectionViewCell
@property (nonatomic,strong) CCVideolistModel *model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end

NS_ASSUME_NONNULL_END
