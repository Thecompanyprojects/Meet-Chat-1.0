//
//  DDCardView.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCDragCardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCardView : CCDragCardView
@property(nonatomic,assign)BOOL isLiked;//可以喜欢
@property(nonatomic,strong)UILabel * label;

- (void)setAnimationwithXYDriection:(ContainerDragDirection)direction;

- (void)setPersonalImage:(NSString*)imageName name:(NSString*)name withAge:(NSString *)age;

-(void)recoverLikeAnimation;

@end

NS_ASSUME_NONNULL_END
