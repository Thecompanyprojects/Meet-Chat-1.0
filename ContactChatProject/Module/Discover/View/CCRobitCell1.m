//
//  CCRobitCell1.m
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCRobitCell1.h"
#import "CCRobitvideoImg.h"

@interface CCRobitCell1()
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) CCRobitvideoImg *videoImg0;
@property (nonatomic,strong) CCRobitvideoImg *videoImg1;
@property (nonatomic,strong) CCRobitvideoImg *videoImg2;
@property (nonatomic,strong) CCRobitvideoImg *videoImg3;

@end

@implementation CCRobitCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.videoImg0];
        [self.contentView addSubview:self.videoImg1];
        [self.contentView addSubview:self.videoImg2];
        [self.contentView addSubview:self.videoImg3];

        [self setuplayout];
    }
    return self;
}

- (void)setModel:(CCDiscoverModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model.videopreview.count==1) {
        
        [self.videoImg0 setHidden:NO];
        [self.videoImg1 setHidden:YES];
        [self.videoImg2 setHidden:YES];
        [self.videoImg3 setHidden:YES];

        NSString *videoUrl0 = [model.videopreview firstObject];
        NSString *NewUrl0 = [videoUrl0 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.videoImg0.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl0] placeholderImage:[UIImage imageNamed:@"videoback"]];
    }
    if (model.videopreview.count==2) {
        
        [self.videoImg0 setHidden:NO];
        [self.videoImg2 setHidden:NO];
        [self.videoImg2 setHidden:YES];
        [self.videoImg3 setHidden:YES];
        
        
        NSString *videoUrl0 = [model.videopreview firstObject];
        NSString *videoUrl1 = [model.videopreview objectAtIndex:1];
        NSString *NewUrl0 = [videoUrl0 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl1 = [videoUrl1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        [self.videoImg0.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl0] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg1.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl1] placeholderImage:[UIImage imageNamed:@"videoback"]];
        
    }
    if (model.videopreview.count==3) {
        
        [self.videoImg0 setHidden:NO];
        [self.videoImg1 setHidden:NO];
        [self.videoImg2 setHidden:NO];
        [self.videoImg3 setHidden:YES];
        
       
        
        NSString *videoUrl0 = [model.videopreview firstObject];
        NSString *videoUrl1 = [model.videopreview objectAtIndex:1];
        NSString *videoUrl2 = [model.videopreview objectAtIndex:2];
        NSString *NewUrl0 = [videoUrl0 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl1 = [videoUrl1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl2 = [videoUrl2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.videoImg0.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl0] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg1.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl1] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg2.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl2] placeholderImage:[UIImage imageNamed:@"videoback"]];
    }
    if (model.videopreview.count>=4) {
        [self.videoImg0 setHidden:NO];
        [self.videoImg1 setHidden:NO];
        [self.videoImg2 setHidden:NO];
        [self.videoImg3 setHidden:NO];
       
        
        NSString *videoUrl0 = [model.videopreview firstObject];
        NSString *videoUrl1 = [model.videopreview objectAtIndex:1];
        NSString *videoUrl2 = [model.videopreview objectAtIndex:2];
        NSString *videoUrl3 = [model.videopreview objectAtIndex:3];
        
        NSString *NewUrl0 = [videoUrl0 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl1 = [videoUrl1 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl2 = [videoUrl2 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *NewUrl3 = [videoUrl3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [self.videoImg0.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl0] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg1.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl1] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg2.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl2] placeholderImage:[UIImage imageNamed:@"videoback"]];
        [self.videoImg3.videoImg sd_setImageWithURL:[NSURL URLWithString:NewUrl3] placeholderImage:[UIImage imageNamed:@"videoback"]];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(17);
        make.left.equalTo(weakSelf).with.offset(20);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(14);
    }];
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.height.mas_offset(1);
        make.width.mas_offset(20);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(5);
    }];
    [weakSelf.videoImg0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.line.mas_bottom).with.offset(10);
        make.width.mas_offset(68);
        make.height.mas_offset(82);
    }];
    [weakSelf.videoImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(68);
        make.height.mas_offset(82);
        make.top.equalTo(weakSelf.videoImg0);
        make.left.equalTo(weakSelf.videoImg0.mas_right).with.offset(10);
    }];
    [weakSelf.videoImg2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.videoImg1.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.videoImg0);
        make.width.mas_offset(68);
        make.height.mas_offset(82);
    }];
    [weakSelf.videoImg3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.videoImg2.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.videoImg0);
        make.width.mas_offset(68);
        make.height.mas_offset(82);
    }];
    
   
}

#pragma mark - getters

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"Video";
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor blackColor];
    }
    return _titleLab;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = MainColor;
    }
    return _line;
}

-(CCRobitvideoImg *)videoImg0
{
    if(!_videoImg0)
    {
        _videoImg0 = [[CCRobitvideoImg alloc] init];
        _videoImg0.userInteractionEnabled = YES;
        _videoImg0.maskImg.userInteractionEnabled = YES;
        _videoImg0.videoImg.userInteractionEnabled = YES;
        [_videoImg0.playBtn addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoChooseClick0:)];
        [_videoImg0 addGestureRecognizer:singleTap];
    }
    return _videoImg0;
}

-(CCRobitvideoImg *)videoImg1
{
    if(!_videoImg1)
    {
        _videoImg1 = [[CCRobitvideoImg alloc] init];
        _videoImg1.userInteractionEnabled = YES;
        _videoImg1.maskImg.userInteractionEnabled = YES;
        _videoImg1.videoImg.userInteractionEnabled = YES;
        [_videoImg1.playBtn addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoChooseClick1:)];
        [_videoImg1 addGestureRecognizer:singleTap];
    }
    return _videoImg1;
}

-(CCRobitvideoImg *)videoImg2
{
    if(!_videoImg2)
    {
        _videoImg2 = [[CCRobitvideoImg alloc] init];
        _videoImg2.userInteractionEnabled = YES;
        _videoImg2.maskImg.userInteractionEnabled = YES;
        _videoImg2.videoImg.userInteractionEnabled = YES;
        [_videoImg2.playBtn addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoChooseClick2:)];
        [_videoImg2 addGestureRecognizer:singleTap];
    }
    return _videoImg2;
}

-(CCRobitvideoImg *)videoImg3
{
    if(!_videoImg3)
    {
        _videoImg3 = [[CCRobitvideoImg alloc] init];
        _videoImg3.userInteractionEnabled = YES;
        _videoImg3.maskImg.userInteractionEnabled = YES;
        _videoImg3.videoImg.userInteractionEnabled = YES;
        [_videoImg3.playBtn addTarget:self action:@selector(btn3click) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoChooseClick3:)];
        [_videoImg3 addGestureRecognizer:singleTap];
        
    }
    return _videoImg3;
}


#pragma mark - 实现方法

-(void)btn0click
{
    NSString *url = [self.model.video firstObject];
    [self.delegate myTabVClick:url];
}

-(void)btn1click
{
    NSString *url = [self.model.video objectAtIndex:1];
    [self.delegate myTabVClick:url];
}

-(void)btn2click
{
    NSString *url = [self.model.video objectAtIndex:2];
    [self.delegate myTabVClick:url];
}

-(void)btn3click
{
    NSString *url = [self.model.video objectAtIndex:3];
    [self.delegate myTabVClick:url];
}

-(void)videoChooseClick0:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *url = [self.model.video firstObject];
    [self.delegate myTabVClick:url];
}

-(void)videoChooseClick1:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *url = [self.model.video objectAtIndex:1];
    [self.delegate myTabVClick:url];
}

-(void)videoChooseClick2:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *url = [self.model.video objectAtIndex:2];
    [self.delegate myTabVClick:url];
}

-(void)videoChooseClick3:(UIGestureRecognizer *)gestureRecognizer
{
    NSString *url = [self.model.video objectAtIndex:3];
    [self.delegate myTabVClick:url];
}

@end

