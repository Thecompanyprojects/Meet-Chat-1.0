//
//  CCDragCardView.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDragConfigure.h"
NS_ASSUME_NONNULL_BEGIN

@interface CCDragCardView : UIView<NSCopying>


@property (nonatomic,assign) CGAffineTransform originTransForm;


@property (nonatomic,strong) CCDragConfigure *configure;

/**
 布局子视图，其子类重写，并在其进行布局
 */
- (void)XYDragCardViewLayoutSubviews;


/**
 执行卡片上动画(喜欢、不喜欢)
 */
- (void)startCardAnimatingForDirection:(ContainerDragDirection)direction;
@end

NS_ASSUME_NONNULL_END
