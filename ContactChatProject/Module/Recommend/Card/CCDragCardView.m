//
//  CCDragCardView.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCDragCardView.h"

@interface CCDragCardView()

@property (nonatomic,strong) UIImageView *like;

@property (nonatomic,strong) UIImageView *dislike;

@end

@implementation CCDragCardView

#pragma mark - Init Method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpConfig];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUpConfig];
}

#pragma mark - Private Method
- (void)setUpConfig
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor cyanColor];
}

#pragma mark - Public Method
- (void)setConfigure:(CCDragConfigure *)configure
{
    _configure = configure;
    self.layer.cornerRadius = configure.cardCornerRadius;
    self.layer.borderWidth = configure.cardCornerBorderWidth;
    self.layer.borderColor = configure.cardBordColor.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)XYDragCardViewLayoutSubviews
{
}


- (void)startCardAnimatingForDirection:(ContainerDragDirection)direction
{
    
}

//实现NSCopying协议的方法，来使此类具有copy功能
-(id)copyWithZone:(NSZone *)zone
{
    CCDragConfigure *newFract = [[CCDragConfigure allocWithZone:zone] init];
    return newFract;
}


@end

