//
//  CCReportViewController.m
//  ContactChatProject
//
//  Created by 王俊钢 on 2019/1/21.
//  Copyright © 2019 pan. All rights reserved.
//

#import "CCReportViewController.h"
#import "XDSDropDownMenu.h"
#import "WJGtextView.h"


#define MAX_LIMIT_NUMS 400

@interface CCReportViewController()<XDSDropDownMenuDelegate,UITextViewDelegate>
@property (nonatomic,strong) XDSDropDownMenu  *nameDropDownMenu;
@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,strong) WJGtextView *feedtext;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,assign) BOOL isSubmit;
@property (nonatomic,strong) UILabel *numberLab;
@property (nonatomic,strong) UIImageView *sanjiaoImg;
@end

@implementation CCReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Report";

    [self.view addSubview:self.chooseBtn];
    self.nameDropDownMenu = [[XDSDropDownMenu alloc] init];
    self.nameDropDownMenu.tag = 1000;
    [self.view addSubview:self.feedtext];
    [self.view addSubview:self.submitBtn];
    [self.view addSubview:self.numberLab];
    [self.view addSubview:self.sanjiaoImg];
    [self setuplayout];
   
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(21);
        if (isIPhoneX_All) {
            make.top.equalTo(weakSelf.view).with.offset(42);
        }
        else
        {
            make.top.equalTo(weakSelf.view).with.offset(20);
        }
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_offset(34);
    }];

    [weakSelf.feedtext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseBtn);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.chooseBtn.mas_bottom).with.offset(40);
        make.height.mas_offset(189);
    }];
    
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.feedtext.mas_bottom).with.offset(40);
        make.left.equalTo(weakSelf.feedtext);
        make.height.mas_offset(42);
    }];
    
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.feedtext.mas_right).with.offset(-5);
        make.bottom.equalTo(weakSelf.feedtext.mas_bottom).with.offset(-8);
        make.height.mas_offset(15);
        make.width.mas_offset(100);
    }];
    [weakSelf.sanjiaoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(10);
        make.height.mas_offset(6);
        make.centerY.equalTo(weakSelf.chooseBtn);
        make.right.equalTo(weakSelf.chooseBtn).with.offset(-4);
    }];
}

#pragma mark - getters

-(UIButton *)chooseBtn
{
    if(!_chooseBtn)
    {
        _chooseBtn = [[UIButton alloc] init];
        [_chooseBtn setTitle:@"Report" forState:normal];
        [_chooseBtn setTitleColor:[UIColor colorWithHexString:@"B1B1B1"] forState:normal];
        _chooseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.layer.masksToBounds = YES;
        _chooseBtn.layer.borderWidth = 1;
        _chooseBtn.layer.borderColor = [UIColor colorWithHexString:@"B1B1B1"].CGColor;
        _chooseBtn.layer.cornerRadius = 2;
        _chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chooseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    return _chooseBtn;
}

-(UIImageView *)sanjiaoImg
{
    if(!_sanjiaoImg)
    {
        _sanjiaoImg = [[UIImageView alloc] init];
        _sanjiaoImg.image = [UIImage imageNamed:@"xiasanjiaod"];
    }
    return _sanjiaoImg;
}


-(WJGtextView *)feedtext
{
    if(!_feedtext)
    {
        _feedtext = [[WJGtextView alloc] init];
        _feedtext.delegate = self;
        _feedtext.customPlaceholder = @"Lewd or harassing content";
        _feedtext.layer.masksToBounds = YES;
        _feedtext.layer.borderWidth = 1;
        _feedtext.layer.cornerRadius = 2;
        _feedtext.layer.borderColor = [UIColor colorWithHexString:@"B1B1B1"].CGColor;
    }
    return _feedtext;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:@"AAAAAA"];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 21;
        [_submitBtn setTitle:@"Put In" forState:normal];
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:normal];
    }
    return _submitBtn;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textColor = [UIColor colorWithHexString:@"B9B9B9"];
        _numberLab.font = [UIFont systemFontOfSize:12];
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.text = [NSString stringWithFormat:@"0/%d",MAX_LIMIT_NUMS];
    }
    return _numberLab;
}


- (void)chooseBtnClick:(UIButton *)sender {
    
    NSArray *arr = @[@"Lewd or harassing content",@"Fraud",@"This account may be compromised"];
    self.nameDropDownMenu.delegate = self;//设置代理
    //调用方法判断是显示下拉菜单，还是隐藏下拉菜单
    [self setupDropDownMenu:self.nameDropDownMenu withTitleArray:arr andButton:sender andDirection:@"down"];
}

#pragma mark - 设置dropDownMenu

/*
 判断是显示dropDownMenu还是收回dropDownMenu
 */

- (void)setupDropDownMenu:(XDSDropDownMenu *)dropDownMenu withTitleArray:(NSArray *)titleArray andButton:(UIButton *)button andDirection:(NSString *)direction{
    
    CGRect btnFrame = button.frame; //如果按钮在UIIiew上用这个
    //  CGRect btnFrame = [self getBtnFrame:button];//如果按钮在UITabelView上用这个
    if(dropDownMenu.tag == 1000){
        //初始化选择菜单
        [dropDownMenu showDropDownMenu:button withButtonFrame:btnFrame arrayOfTitle:titleArray arrayOfImage:nil animationDirection:direction];
        
        //添加到主视图上
        [self.view addSubview:dropDownMenu];
        
        //将dropDownMenu的tag值设为2000，表示已经打开了dropDownMenu
        dropDownMenu.tag = 2000;
        self.sanjiaoImg.image = [UIImage imageNamed:@"sanjiaoxiangshang"];
    }else {
        
        /*
         如果dropDownMenu的tag值为2000，表示dropDownMenu已经打开，则隐藏dropDownMenu
         */
        
//        self.isSubmit = YES;
//        self.submitBtn.backgroundColor = MainColor;

        [dropDownMenu hideDropDownMenuWithBtnFrame:btnFrame];
        dropDownMenu.tag = 1000;
        self.sanjiaoImg.image = [UIImage imageNamed:@"xiasanjiaod"];
        
    }
}

#pragma mark - 下拉菜单代理
/*
 在点击下拉菜单后，将其tag值重新设为1000
 */

- (void)setDropDownDelegate:(XDSDropDownMenu *)sender{
    sender.tag = 1000;
    self.sanjiaoImg.image = [UIImage imageNamed:@"xiasanjiaod"];
    self.submitBtn.backgroundColor = MainColor;
    self.isSubmit = YES;
    [self.chooseBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:normal];
}

#pragma mark UITextViewDelegate

//正在改变
- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
    
    //实时显示字数
    self.numberLab.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length,MAX_LIMIT_NUMS];
    //字数限制操作
    if (textView.text.length >= MAX_LIMIT_NUMS) {
        textView.text = [textView.text substringToIndex:MAX_LIMIT_NUMS];
       self.numberLab.text = [NSString stringWithFormat:@"%d/%d",MAX_LIMIT_NUMS,MAX_LIMIT_NUMS];
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"No more than %d characters",MAX_LIMIT_NUMS]];
        });
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"/n"]) {
        [textView resignFirstResponder];
    }
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text]; if ([string length] > MAX_LIMIT_NUMS)
    {
        string = [string substringToIndex:MAX_LIMIT_NUMS];
    }
    textView.text = string;
    NSInteger remainTextNum_= MAX_LIMIT_NUMS; //计算剩下多少文字可以输入
    if(range.location>=MAX_LIMIT_NUMS)
        { remainTextNum_=0;
            return NO;
            
        } else {
            NSString *nsTextContent=textView.text;
            NSInteger existTextNum=[nsTextContent length];
            remainTextNum_=MAX_LIMIT_NUMS-existTextNum;
            return YES;
        }
    return YES;
}

#pragma mark - submitClick

-(void)submitbtnClick
{
    if (self.isSubmit) {
        [CCLoadingHUD show];
        int64_t delayInSeconds = 1.5; // 延迟的时间
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CCLoadingHUD dismiss];
            [SVProgressHUD showInfoWithStatus:@"Report Success"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
