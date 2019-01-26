//
//  CCDragCardContainer.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDragCardView.h"
@class CCDragCardContainer;

@protocol XYDragCardContainerDataSource <NSObject>

@required

/** 数据源个数 **/
- (NSInteger)numberOfRowsInXYLDragCardContainer:(CCDragCardContainer *)container;

/** 显示数据源 **/
- (CCDragCardView *)dragViewContainer:(CCDragCardContainer *)container viewForRowsAtIndex:(NSInteger)index;

@end

@protocol XYDragCardContainerDelegate <NSObject>

@optional

/** 点击卡片回调 **/
- (void)dragCardContainer:(CCDragCardContainer *)container didSelectRowAtIndex:(NSInteger)index;

/** 拖到最后一张卡片 YES，空，可继续调用reloadData分页数据**/
- (void)dragCardContainer:(CCDragCardContainer *)container dataSourceIsEmpty:(BOOL)isEmpty;

/**  当前cardview 是否可以拖拽，默认YES **/
- (BOOL)dragCardContainer:(CCDragCardContainer *)container canDragForCardView:(CCDragCardView *)cardView;

/** 卡片处于拖拽中回调**/
- (void)dragCardContainer:(CCDragCardContainer *)container dargingForCardView:(CCDragCardView *)cardView direction:(ContainerDragDirection)direction widthRate:(float)widthRate  heightRate:(float)heightRate;

/** 卡片拖拽结束回调（卡片消失） **/
- (void)dragCardContainer:(CCDragCardContainer *)container dragDidFinshForDirection:(ContainerDragDirection)direction forCardView:(CCDragCardView *)cardView;

/** 卡片拖拽（卡片消失） **/
- (void)dragCardContainer:(CCDragCardContainer *)container dragDisappearForDirection:(ContainerDragDirection)direction forCardView:(CCDragCardView *)cardView;

@end


@interface CCDragCardContainer : UIView


/** 初始化方法 **/
- (instancetype)initWithFrame:(CGRect)frame configure:(CCDragConfigure*)configure;

/** 默认初始化方法 **/
- (instancetype)initWithFrame:(CGRect)frame;

/** 数据源代理 **/
@property (nonatomic, weak, nullable) id <XYDragCardContainerDataSource> dataSource;

/**  动作代理 **/
@property (nonatomic, weak, nullable) id <XYDragCardContainerDelegate> delegate;

/** 刷新数据 **/
- (void)cardReloadData;

/** 主动调用拖拽 **/
- (void)removeXyCardViewForDirection:(ContainerDragDirection)direction;

/** 主动调用撤回*/
-(void)addCardViewForDragDirection:(ContainerDragDirection)direction withCardView:(CCDragCardView *)cardView;

/** 获取显示当前卡片 **/
- (CCDragCardView *)getCurrentNeedShowCardView;

/** 获取显示当前卡片的index **/
- (NSInteger)getCurrentNeedShowCardViewIndex;

@end

