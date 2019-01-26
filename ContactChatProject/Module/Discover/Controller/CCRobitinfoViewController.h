//
//  CCRobitinfoViewController.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BaseViewController.h"

#import "CCDiscoverModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnPeopleBlock)(BOOL peopleIndex);

typedef NS_ENUM (NSInteger, RobotinfofromType)   {
    
    RobotinfofromDis = 0,
    RobotinfofromActive = 1,
    RobotinfofromLiked = 2,
    RobotinfofromShake = 3
};

@interface CCRobitinfoViewController : BaseViewController
@property (nonatomic,strong) CCDiscoverModel *model;
@property (nonatomic, copy) ReturnPeopleBlock returnPeopleBlock;
@property (nonatomic,assign) RobotinfofromType type;
@end


NS_ASSUME_NONNULL_END
