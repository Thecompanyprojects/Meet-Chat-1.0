//
//  CCPersonalCell3.m
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCPersonalCell3.h"

@implementation CCPersonalCell3

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.typeImg];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.typeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(18);
        make.height.mas_offset(18);
        make.left.equalTo(weakSelf).with.offset(20);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.typeImg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-20);
    }];
}

#pragma mark - getters

-(UIImageView *)typeImg
{
    if(!_typeImg)
    {
        _typeImg = [[UIImageView alloc] init];
        _typeImg.image = [UIImage imageNamed:@"hi"];
    }
    return _typeImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor colorWithHexString:@"333333"];
        _contentLab.font = [UIFont systemFontOfSize:14];
        
    }
    return _contentLab;
}

@end
