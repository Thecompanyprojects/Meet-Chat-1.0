//
//  CCRobitCell1.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDiscoverModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol myTabVdelegate <NSObject>
-(void)myTabVClick:(NSString *)vieoUrl;
@end

@interface CCRobitCell1 : UITableViewCell
@property (nonatomic,strong) CCDiscoverModel *model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end

NS_ASSUME_NONNULL_END
