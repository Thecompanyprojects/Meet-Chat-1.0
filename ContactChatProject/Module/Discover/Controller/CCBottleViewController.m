//
//  CCBottleViewController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCBottleViewController.h"
#import "CCbottleAlertView.h"
#import "CCgetbottleAlertView.h"
#import "CCRobitinfoViewController.h"
#import "ChatSendManager.h"

@interface CCBottleViewController ()
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *bottleImg;
@property (nonatomic,strong) UIImageView *barreliImg;
@property (nonatomic,strong) UIImageView *shadowImg0;
@property (nonatomic,strong) UIImageView *showImg;
@property (nonatomic,strong) UIImageView *newbottleImg;
@property (nonatomic,strong) UIImageView *dropsImg;
@property (nonatomic,assign) BOOL iscanGet;
@end

@implementation CCBottleViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Drift bottle";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"30b1e9"];
    self.navigationController.navigationBar.translucent = NO;
    [self logManager];
    [self delNavLine];
    self.iscanGet = YES;
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.bottleImg];
    [self.view addSubview:self.barreliImg];
    [self.view addSubview:self.shadowImg0];
    [self.view addSubview:self.showImg];
    [self.view addSubview:self.newbottleImg];
    [self.view addSubview:self.dropsImg];
    [self CCsetuplayout];
}

-(void)CCsetuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    [weakSelf.barreliImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(74);
        make.height.mas_offset(70);
        make.bottom.equalTo(weakSelf.view).with.offset(-35);
        make.right.equalTo(weakSelf.view).with.offset(-44);
    }];
    
    [weakSelf.bottleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(-35);
        make.height.mas_offset(79);
        make.left.equalTo(weakSelf.view).with.offset(44);
        make.width.mas_offset(147);
    }];
    
    [weakSelf.shadowImg0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
        
    }];
    
    [weakSelf.showImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(147);
        make.height.mas_offset(79);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(330*KHEIGHT);
    }];
    
    [weakSelf.newbottleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).with.offset(-140*KHEIGHT);
        make.left.equalTo(weakSelf.view).with.offset(66);
        make.height.mas_offset(55);
        make.width.mas_offset(110);
    }];
    
    [weakSelf.dropsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
        make.width.mas_offset(50);
        make.height.mas_offset(32);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                  NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"30b1e9"];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                  NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [super viewWillDisappear:animated];
}

#pragma mark - getters

-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"hai"];
        _bgImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CCshowclick)];
        [_bgImg addGestureRecognizer:tapGesturRecognizer];
    }
    return _bgImg;
}

-(UIImageView *)bottleImg
{
    if(!_bottleImg)
    {
        _bottleImg = [[UIImageView alloc] init];
        _bottleImg.image = [UIImage imageNamed:@"pingzi"];
        _bottleImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CCgetbottle)];
        [_bottleImg addGestureRecognizer:tapGesturRecognizer];
    }
    return _bottleImg;
}

-(UIImageView *)barreliImg
{
    if(!_barreliImg)
    {
        _barreliImg = [[UIImageView alloc] init];
        _barreliImg.image = [UIImage imageNamed:@"tong"];
        _barreliImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CCscoopupClick)];
        [_barreliImg addGestureRecognizer:tapGesturRecognizer];
    }
    return _barreliImg;
}

-(UIImageView *)shadowImg0
{
    if(!_shadowImg0)
    {
        _shadowImg0 = [[UIImageView alloc] init];
        
        [_shadowImg0 setHidden:YES];
        _shadowImg0.image = [UIImage imageNamed:@"bottlebg1"];
    }
    return _shadowImg0;
}

-(UIImageView *)showImg
{
    if(!_showImg)
    {
        _showImg = [[UIImageView alloc] init];
        [_showImg setHidden:YES];
        _showImg.image = [UIImage imageNamed:@"pingzi"];
        _showImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(findbottleclick)];
        [_showImg addGestureRecognizer:tapGesturRecognizer];
    }
    return _showImg;
}

-(UIImageView *)newbottleImg
{
    if(!_newbottleImg)
    {
        _newbottleImg = [[UIImageView alloc] init];
        _newbottleImg.image = [UIImage imageNamed:@"pingzi"];
        [_newbottleImg setHidden:YES];
    }
    return _newbottleImg;
}

-(UIImageView *)dropsImg
{
    if(!_dropsImg)
    {
        _dropsImg = [[UIImageView alloc] init];
        
    }
    return _dropsImg;
}


#pragma mark - 捡瓶子

-(void)CCscoopupClick
{
    if ([self isshouldUpload]) {
        [self UploadthePhoto];
        return;
    }
    [self CCbuildAnimationImageView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.shadowImg0 setHidden:NO];
        [self.showImg setHidden:NO];
    });
}

#pragma mark - 隐藏不显示瓶子

-(void)CCshowclick
{
    [self.showImg setHidden:YES];
    [self.shadowImg0 setHidden:YES];
}

#pragma mark - 打开瓶子

-(void)findbottleclick
{
    if(self.iscanGet)
    {
        [WJGAFCheckNetManager shareTools].type = checkNetTypeWithbottle;
        [[WJGAFCheckNetManager shareTools] checkNetWithBlock];
        [[AFNetAPIClient sharedClient] requestUrl:findbottle cParameters:[NSDictionary new] success:^(NSDictionary * _Nonnull requset) {
            if ([[requset objectForKey:@"code"] intValue]==1) {
                
                CCDiscoverModel *model = [CCDiscoverModel new];
                NSDictionary *data = [requset objectForKey:@"data"];
                NSDictionary *botinfo = [data objectForKey:@"botinfo"];
                model = [CCDiscoverModel yy_modelWithDictionary:botinfo];
                
                [self logManagerwithPoptype:@{@"result":@"1"}];
                
                //显示瓶子内容
                CCgetbottleAlertView *alertView = [CCgetbottleAlertView new];
                alertView.nameLab.text = model.name?:@"";
                alertView.ageLab.text = model.age?:@"0";
                alertView.contentLab.text = model.signature?:@"";
                
                if (model.photopreview.count!=0) {
                    [alertView.coverImg sd_setImageWithURL:[NSURL URLWithString:[model.photopreview firstObject]] placeholderImage:[UIImage imageNamed:@"backImg2"]];
                }
                
                id contentid = [data objectForKey:@"content"];
                if ([contentid isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *bottlecontent = [data objectForKey:@"content"];
                    NSString *msg = [bottlecontent objectForKey:@"msg"];
                    alertView.messageLab.text = msg?:@"";
                }
                
                
                if ([model.sex isEqualToString:@"m"]) {
                    alertView.sexImg.image = [UIImage imageNamed:@"boy"];
                }
                else
                {
                    alertView.sexImg.image = [UIImage imageNamed:@"girl"];
                }
                
                [alertView withrepylClick:^(NSString * _Nonnull string) {
                    if ([contentid isKindOfClass:[NSDictionary class]]) {
                        //跳转到聊天界面
                        CCMessageItem * item = [[CCMessageItem alloc]init];
                        item.userId = model.Newid;
                        item.userName = model.name;
                        NSInteger type = [[data objectForKey:@"contenttype"] integerValue];
                        item.msgType = type - 1;
                        if (type == 1) {
                            item.message = [[[data objectForKey:@"content"] safeObj:@"msg"]filtrationSpecailCharactor];
                        }else if (type == 2){
                            item.message = [[data objectForKey:@"content"] safeObj:@"photo"];
                        }else if (type == 3){
                            item.message = [NSString stringWithFormat:@"%@||%@",[[data objectForKey:@"content"] safeObj:@"videopreview"],[[data objectForKey:@"content"] safeObj:@"video"]];
                        }
                        item.photo = model.photopreview.firstObject;
                        item.createDate = [NSDate date].timeIntervalSince1970 * 1000;
                        item.sendUserId = model.Newid;
                        [[ChatSendManager sharedInstance] senderMessage:item withAfterSecond:0];
                        CCMessageDetailController * messageDetail = [[CCMessageDetailController alloc]initWithNibName:NSStringFromClass([CCMessageDetailController class]) bundle:nil];
                        messageDetail.msgItem = item;
                        [self.navigationController pushViewController:messageDetail animated:YES];
                        
                    }
                    
                    [self logManagerwithPickuptype:@{@"result":@"0"}];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.shadowImg0 setHidden:YES];
                        [self.showImg setHidden:YES];
                    });
                    self.iscanGet = YES;
                }];
                [alertView withDismissClick:^(NSString * _Nonnull string) {
                    [self CCmakedownAnimation];
                    [self logManagerwithPickuptype:@{@"pick_up":@"1"}];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self CCshowclick];
                        self.iscanGet = YES;
                    });
                    
                }];
                
            }
            else
            {
//                [[XYLogManager shareManager] addLogKey1:@"data" key2:@"error" content:@{@"type":@(3)} userInfo:[NSDictionary new] upload:NO];
            }
            self.iscanGet = YES;
        } failure:^(NSError * _Nonnull error) {
            self.iscanGet = YES;
//            [[XYLogManager shareManager] addLogKey1:@"data" key2:@"overtime" content:@{@"type":@(3)} userInfo:[NSDictionary new] upload:NO];
        }];
    }
    self.iscanGet = NO;
}

#pragma mark -扔瓶子

-(void)CCgetbottle
{
    
    if ([self isshouldUpload]) {
        [self UploadthePhoto];
        return;
    }
    
    [self CCshowclick];
    [self logManagerwithPoptype:@{@"result":@"0"}];
    CCbottleAlertView *alertView = [[CCbottleAlertView alloc] init];
    alertView.nameLab.text =  [CCUserModel sharedUserModel].name?:@"";
    if (![[CCUserModel sharedUserModel].signature isKindOfClass:[NSNull class]]) {
        alertView.contentLab.text = [CCUserModel sharedUserModel].signature?:@"";
    }
    if (![[CCUserModel sharedUserModel].age isKindOfClass:[NSNull class]]) {
        alertView.ageLab.text = [CCUserModel sharedUserModel].age?:@"0";
    }
    else
    {
        alertView.ageLab.text = @"0";
    }
    if ([[CCUserModel sharedUserModel].sex isEqualToString:@"m"]) {
        alertView.sexImg.image = [UIImage imageNamed:@"男"];
    }
    else
    {
        alertView.sexImg.image = [UIImage imageNamed:@"女"];
    }
    NSArray *photoarr = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphoto"];
    if (photoarr.count!=0) {
        [alertView.coverImg sd_setImageWithURL:[NSURL URLWithString:[photoarr firstObject]] placeholderImage:[UIImage imageNamed:@"backImg2"]];
    }
    
    
    
    [alertView withrepylClick:^(NSString * _Nonnull string) {
        
        self.newbottleImg.hidden = NO;
        
        NSString *Newstring= [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (Newstring.length!=0) {
            [UIView animateWithDuration:0.3 animations:^{
                [alertView removeFromSuperview];
            }];
            
            NSString *content = string;
            NSString *lang = @"en";
            NSDictionary *dic = @{@"content":content?:@"",@"lang":lang};
            [self logManagerwithThrowtype:@{@"result":@"0"}];

            [self CCmakeGoOnAnimation];
           
            [[AFNetAPIClient sharedClient] requestUrl:throwbottle cParameters:dic success:^(NSDictionary * _Nonnull requset) {
                if ([[requset objectForKey:@"code"] intValue]==1) {
                    [SVProgressHUD showInfoWithStatus:@"Success!"];
                }
            } failure:^(NSError * _Nonnull error) {
                
            }];
            
        }
        else
        {
            
            [SVProgressHUD showInfoWithStatus:@"Input cannot be empty"];
            [self.newbottleImg setHidden:YES];
        }
    }];
}


-(void)CCmakeGoOnAnimation{
    //定义一个动画开始的时间
    CFTimeInterval currentTime = CACurrentMediaTime();
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(180*KWIDTH, kScreenHeight-230*KHEIGHT)];
    positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    positionAni.duration = 1.5f;
    positionAni.fillMode = kCAFillModeForwards;
    positionAni.removedOnCompletion = NO;
    positionAni.beginTime = currentTime;
    [self.newbottleImg.layer addAnimation:positionAni forKey:@"positionAnimation"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.5f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.duration = 2.0f;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = YES;
    [self.newbottleImg.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    CAAnimationGroup *groupAni = [CAAnimationGroup animation];
    groupAni.animations = [NSArray arrayWithObjects:positionAni,scaleAnimation,nil];
    [self.newbottleImg.layer addAnimation:groupAni forKey:@"groupAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.newbottleImg setHidden:YES];
    });
    
}

-(void)CCmakedownAnimation
{
    CFTimeInterval currentTime = CACurrentMediaTime();
    
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    positionAni.toValue = [NSValue valueWithCGPoint:CGPointMake(kScreenWidth/2, kScreenWidth/2*2.5)];
    positionAni.duration = 1.5f;
    positionAni.fillMode = kCAFillModeForwards;
    positionAni.removedOnCompletion = YES;
    positionAni.beginTime = currentTime;
    [self.showImg.layer addAnimation:positionAni forKey:@"positionAnimation"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.8f];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.0];
    scaleAnimation.duration = 1.5f;
    scaleAnimation.fillMode = kCAFillModeForwards;
    scaleAnimation.removedOnCompletion = YES;
    [self.showImg.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    
    CAAnimationGroup *groupAni = [CAAnimationGroup animation];
    groupAni.animations = [NSArray arrayWithObjects:positionAni,scaleAnimation,nil];
    [self.showImg.layer addAnimation:groupAni forKey:@"groupAnimation"];
}

- (void)CCbuildAnimationImageView
{
    NSArray *array = @[[UIImage imageNamed:@"shuihua1"],
                       [UIImage imageNamed:@"shuihua2"],];
    self.dropsImg.animationImages = array;              //设置图像视图的动画图片属性
    self.dropsImg.animationDuration = 2;                //设置帧动画时长
    self.dropsImg.animationRepeatCount = 1;             //设置无限次循环
    self.dropsImg.contentMode = UIViewContentModeCenter;
    [self.dropsImg startAnimating];
}


#pragma mark - 打点上报

-(void)logManager
{
//    [[XYLogManager shareManager] addLogKey1:@"drift_bottle" key2:@"show" content:[NSDictionary new] userInfo:[NSDictionary new] upload:YES];
    
}

//result:0/1 0：扔瓶子的弹窗  1:捡瓶子的弹窗

-(void)logManagerwithPoptype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"drift_bottle" key2:@"Popup" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}

//pick_up 捡  result:0/1 0:回复 1：扔回去

-(void)logManagerwithPickuptype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"drift_bottle" key2:@"pick_up" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}

//throw result:0/1 0:扔出去 1：取消

-(void)logManagerwithThrowtype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"drift_bottle" key2:@"throw" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}
@end
