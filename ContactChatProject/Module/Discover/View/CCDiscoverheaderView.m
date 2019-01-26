//
//  CCDiscoverheaderView.m
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCDiscoverheaderView.h"

@interface CCDiscoverheaderView()
@property (nonatomic,strong) NSMutableArray *masonryViewArray;
@property (nonatomic,strong) UILabel *typeLab;
@end

@implementation CCDiscoverheaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn0];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.btn3];
        
        [self addSubview:self.titleLab0];
        [self addSubview:self.titleLab1];
        [self addSubview:self.titleLab2];
        [self addSubview:self.titleLab3];
        
        [self addSubview:self.typeLab];

        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    self.masonryViewArray = [NSMutableArray array];
    [self.masonryViewArray addObject:self.btn0];
    [self.masonryViewArray addObject:self.btn1];
    [self.masonryViewArray addObject:self.btn2];
    [self.masonryViewArray addObject:self.btn3];
    
    // 实现masonry水平固定控件宽度方法
    [weakSelf.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:48 leadSpacing:36 tailSpacing:36];
    
    // 设置array的垂直方向的约束
    [weakSelf.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(15);
        make.height.mas_offset(48);
    }];
    
    [weakSelf.titleLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.btn0.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf.btn0);
        make.height.mas_offset(12);
    }];
    [weakSelf.titleLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab0);
        make.centerX.equalTo(weakSelf.btn1);
        make.height.mas_offset(12);
    }];
    [weakSelf.titleLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab0);
        make.centerX.equalTo(weakSelf.btn2);
        make.height.mas_offset(12);
    }];
    [weakSelf.titleLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab0);
        make.centerX.equalTo(weakSelf.btn3);
        make.height.mas_offset(12);
    }];
    
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.top.equalTo(weakSelf.titleLab2.mas_bottom).with.offset(32);
    }];

}

#pragma mark - getters

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        
    }
    return _btn2;
}

-(UIButton *)btn3
{
    if(!_btn3)
    {
        _btn3 = [[UIButton alloc] init];
        
    }
    return _btn3;
}

-(UILabel *)titleLab0
{
    if(!_titleLab0)
    {
        _titleLab0 = [[UILabel alloc] init];
        _titleLab0.textAlignment = NSTextAlignmentCenter;
        _titleLab0.font = [UIFont systemFontOfSize:12];
        _titleLab0.textColor = [UIColor colorWithHexString:@"666666"];
        
    }
    return _titleLab0;
}

-(UILabel *)titleLab1
{
    if(!_titleLab1)
    {
        _titleLab1 = [[UILabel alloc] init];
        _titleLab1.textAlignment = NSTextAlignmentCenter;
        _titleLab1.font = [UIFont systemFontOfSize:12];
        _titleLab1.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _titleLab1;
}

-(UILabel *)titleLab2
{
    if(!_titleLab2)
    {
        _titleLab2 = [[UILabel alloc] init];
        _titleLab2.textAlignment = NSTextAlignmentCenter;
        _titleLab2.font = [UIFont systemFontOfSize:12];
        _titleLab2.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _titleLab2;
}

-(UILabel *)titleLab3
{
    if(!_titleLab3)
    {
        _titleLab3 = [[UILabel alloc] init];
        _titleLab3.textAlignment = NSTextAlignmentCenter;
        _titleLab3.font = [UIFont systemFontOfSize:12];
        _titleLab3.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _titleLab3;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:16];
        _typeLab.textColor = [UIColor colorWithHexString:@"000000"];
        _typeLab.text = @"Find a friend";
    }
    return _typeLab;
}





@end
