//
//  CCVideoPlayController.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BaseViewController.h"
#import "CCVideolistModel.h"
#import "CCDiscoverModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnPeopleBlock)(BOOL isSayHi);

typedef NS_ENUM (NSInteger, RobotvideofromType)   {
    
    RobotvideofromList = 0,
    RobotvideofromDis = 1,
    RobotvideofromActive = 2,
    RobotvideofromLiked = 3,
    RobotvideofromShake = 4,
};

@interface CCVideoPlayController : BaseViewController
@property (nonatomic,strong) CCVideolistModel *model;
@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic, copy) ReturnPeopleBlock returnPeopleBlock;
@property (nonatomic,strong) CCDiscoverModel *disModel;
@property (nonatomic,assign) BOOL isfromDis;
@property (nonatomic,assign) BOOL issayHi;
@property (nonatomic,assign) BOOL isfromlikedme;

@property (nonatomic,assign) RobotvideofromType type;
-(void)returnPeopleindex:(ReturnPeopleBlock)block;
@end

NS_ASSUME_NONNULL_END
