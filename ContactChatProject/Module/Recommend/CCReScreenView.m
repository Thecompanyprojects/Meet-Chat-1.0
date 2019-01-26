//
//  CCReScreenView.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCReScreenView.h"
#import "CCSelectButton.h"
#import "CCDoubleSlider.h"


@interface CCReScreenView ()<DoubleSliderDelegate>
@property(nonatomic,strong) CCDoubleSlider * slider;
@property(nonatomic,weak)IBOutlet UILabel * ageLabel;
@property(nonatomic,copy)NSString * sex;
@property(nonatomic,copy)NSArray * ages;
@property(nonatomic,strong)NSNumber * active; //活跃度
@end

@implementation CCReScreenView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _slider = [[CCDoubleSlider alloc]initWithFrame:CGRectMake(20, 95, kScreenWidth - 40, 40)];
    _slider.minNum = 18;
    _slider.maxNum = 40;
    _slider.minTintColor = [UIColor colorWithHexString:@"#999999"];
    _slider.maxTintColor = [UIColor  colorWithHexString:@"#999999"];
    _slider.mainTintColor = MainColor;
    _slider.delegate = self;
    self.sex = @"";
    self.active = @1;
    self.ages = @[@18,@40];
    [self addSubview:_slider];
}
-(void)ageSliderValueChange:(CCDoubleSlider *)slider{
    if ((int)slider.currentMaxValue == (int)slider.currentMinValue) {
        self.ageLabel.text = [NSString stringWithFormat:@"(%d)",(int)slider.currentMinValue];
    }else{
        self.ageLabel.text = [NSString stringWithFormat:@"(%d-%d)",(int)slider.currentMinValue,(int)slider.currentMaxValue];
    }
    self.ages = @[@((int)slider.currentMinValue),@((int)slider.currentMaxValue)];
}
-(IBAction)confirmOKClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(screeenPassDicValue:)]) {
        [self.delegate screeenPassDicValue:@{@"age":self.ages,
                                          @"active":self.active
                                          }];
//        [[XYLogManager shareManager] addLogKey1:@"screen" key2:@"select" content:@{@"type":@(0)} userInfo:[NSDictionary new] upload:YES];
//        [[XYLogManager shareManager] addLogKey1:@"screen" key2:@"select" content:@{@"type":@(1)} userInfo:[NSDictionary new] upload:YES];
    }
}
-(IBAction)sexClick:(CCSelectButton *)sender{
    NSArray * sexValues = @[@"",@"m",@"f"];
    CCSelectButton * btn0 = [self viewWithTag:200];
    CCSelectButton * btn1 = [self viewWithTag:201];
    CCSelectButton * btn2 = [self viewWithTag:202];
    btn0.selected = NO;
    btn1.selected = NO;
    btn2.selected = NO;
    sender.selected = YES;
    self.sex = sexValues[sender.tag - 200];
}
-(IBAction)agetClick:(CCSelectButton *)sender{
    
}
-(IBAction)closeButtonClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(screeenPassDicValue:)]) {
        [self.delegate screeenPassDicValue:nil];
    }
}
-(IBAction)activityClick:(CCSelectButton *)sender{
    NSArray * activityValues = @[@1,@2,@3,@4];
    CCSelectButton * btn0 = [self viewWithTag:300];
    CCSelectButton * btn1 = [self viewWithTag:301];
    CCSelectButton * btn2 = [self viewWithTag:302];
    CCSelectButton * btn3 = [self viewWithTag:303];
    btn0.selected = NO;
    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    sender.selected = YES;
    self.active = activityValues[sender.tag - 300];
    
}
@end
