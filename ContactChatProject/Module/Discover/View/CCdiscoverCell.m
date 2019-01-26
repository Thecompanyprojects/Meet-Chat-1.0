//
//  CCdiscoverCell.m
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCdiscoverCell.h"

@interface CCdiscoverCell()
@property (nonatomic,strong) UIButton *changeBtn;
@property (nonatomic,strong) UIImageView *effView;
@end

@implementation CCdiscoverCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.effView];
        [self.contentView addSubview:self.changeBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(126);
    }];
    
    [weakSelf.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(42);
        make.height.mas_offset(42);
        make.centerX.equalTo(weakSelf.coverImg);
        make.top.equalTo(weakSelf.coverImg.mas_bottom).with.offset(-21);
    }];
    
    [weakSelf.effView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(30);
        make.width.mas_offset(30);
    }];
}

- (void)newsetModel:(CCDiscoverModel *)model
{
    [self.effView setHidden:YES];
    if (model.photopreview.count!=0) {
        NSString *imgUrl = [[model.photopreview firstObject] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.coverImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"backImg2"]];
    }
    else
    {
        self.coverImg.image = [UIImage imageNamed:@"backImg2"];
    }
    
    if (model.issayHi) {
        [self.changeBtn setImage:[UIImage imageNamed:@"hi2"] forState:normal];
    }
    else
    {
        [self.changeBtn setImage:[UIImage imageNamed:@"hi"] forState:normal];
    }
}

#pragma mark - getters


-(UIImageView *)effView
{
    if(!_effView)
    {
        _effView = [[UIImageView alloc] init];
        _effView.image = [UIImage imageNamed:@"mengban"];
    }
    return _effView;
}


-(UIImageView *)coverImg
{
    if(!_coverImg)
    {
        _coverImg = [[UIImageView alloc] init];
        _coverImg.layer.masksToBounds = YES;
        _coverImg.contentMode =  UIViewContentModeScaleAspectFill;
    }
    return _coverImg;
}

-(UIButton *)changeBtn
{
    if(!_changeBtn)
    {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setImage:[UIImage imageNamed:@"hi"] forState:normal];
        [_changeBtn addTarget:self action:@selector(changebtnClick) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _changeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
        // [_changeBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    }
    return _changeBtn;
}

-(void)changebtnClick
{
    [self.delegate myTabVClick:self];
}

@end
