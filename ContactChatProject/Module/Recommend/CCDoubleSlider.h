//
//  CCDoubleSlider.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCDoubleSlider : UIView
@property(nonatomic,assign)id delegate;
/**
 设置最小值
 */
@property (nonatomic,assign)CGFloat minNum;

/**
 设置最大值
 */
@property (nonatomic,assign)CGFloat maxNum;

/**
 设置min 颜色
 */
@property (nonatomic,weak)UIColor *minTintColor;

/**
 设置max 颜色
 */
@property (nonatomic,weak)UIColor *maxTintColor;

/**
 设置 中间 颜色
 */
@property (nonatomic,weak)UIColor *mainTintColor;

/**
 显示较小的数Label
 */
@property (nonatomic,strong)UILabel *minLabel;

/**
 显示较大的数Label
 */
@property (nonatomic,strong)UILabel *maxLabel;

/**
 当前最小值
 */
@property (nonatomic,assign)CGFloat  currentMinValue;

/**
 当前最大值
 */
@property (nonatomic,assign)CGFloat  currentMaxValue;

/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIButton *minSlider;

/**
 显示 max 滑块
 */
@property (nonatomic,strong)UIButton *maxSlider;

/**
 设置单位
 */
@property (nonatomic,copy)NSString * unit;
@end


@protocol DoubleSliderDelegate <NSObject>

-(void)ageSliderValueChange:(CCDoubleSlider *)slider;
@end

NS_ASSUME_NONNULL_END
