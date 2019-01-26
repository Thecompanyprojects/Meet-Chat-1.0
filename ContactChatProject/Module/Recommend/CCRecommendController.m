//
//  CCRecommendController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCRecommendController.h"
#import "CCDragCardContainer.h"
#import "CCReScreenView.h"
#import "DDCardView.h"
#import "XYNetworkRequest.h"
#import "XYNetworkTools.h"
#import "NSString+AdBlowfish.h"
#import "CCLoadingHUD.h"
#import "ChatManager.h"
#import "ChatSendManager.h"
#import "NSString+SKYExtension.h"
#import "NSDate+Extension.h"
#import "AppDelegate.h"
#import "CCPhotoView.h"

@interface CCRecommendController ()
<XYDragCardContainerDataSource,XYDragCardContainerDelegate,UIGestureRecognizerDelegate,ScreenDelegate>

@property (nonatomic,strong) NSMutableArray <NSString*>*names;
@property (nonatomic,strong) NSMutableArray * sources;
@property (nonatomic,strong) NSMutableArray <NSString*>*titles;
@property (nonatomic,strong)  CCDragCardContainer *container;
@property (nonatomic,strong) NSMutableArray <UIButton*>*controllers;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)NSMutableDictionary * parameters;
@property(nonatomic,strong)CCReScreenView * screenView;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)NSInteger totldPage;
@property(nonatomic,copy)NSString * yymDate;
@property(nonatomic,strong)UIView * emptyView;
@property(nonatomic,strong)DDCardView * lastCardView;
@property(nonatomic,assign)ContainerDragDirection lastDragDirection;
@property(nonatomic,strong)UIView * shadeView;
@end

@implementation CCRecommendController

#define ScrrenHeight  330.0

static const NSInteger PageSize = 50;
static const NSInteger CriSize = 30; //临界值

#pragma mark - ViewController  Life
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 侧滑手势开启
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
    NSInteger year =  [[NSDate date] year];
    NSInteger month = [[NSDate date] month];
    NSInteger day =  [[NSDate date] day];
    self.yymDate = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"000000"];
    [self addxyNavigationButtonItems];
    
    self.controllers = [[NSMutableArray alloc]init];
    [self loadBottomButtons];
    
    [self setUpContainer];
    
    
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                      @"age":@[@18,@40],
                                                                      @"active":@(4),
                                                                      @"size":@(PageSize),
                                                                      @"id":[CCUserModel sharedUserModel].userId?:@(0)}];
    self.sources = [NSMutableArray array];
    self.pageNum = 1;
    [self loadData:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVIP) name:@"VPSHOW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUploadView) name:@"UPLOADIMAGESHOW" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showVideo) name:@"VPSHOWVIDEO" object:nil];
    
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"dingyue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(openVIP)];
    //
    [self ObserverNotifity];
}
#pragma mark 网络请求
-(void)loadData:(BOOL)reload{
    __weak __typeof(&*self)weakSelf =self;
    [WJGAFCheckNetManager shareTools].type = checkNetTypeWithrecommend;
    [[WJGAFCheckNetManager shareTools] checkNetWithBlock];
    [[AFNetAPIClient sharedClient] requestUrl:SocicalchatFiltrate cParameters:self.parameters success:^(NSDictionary * response) {
        NSLog(@"response----%@",response);
        [CCLoadingHUD dismiss];
        if ([[response objectForKey:@"code"] isEqual:@1]) {
            NSDictionary * data = [response objectForKey:@"data"];
            if ([[data objectForKey:@"botlist"] isKindOfClass:[NSArray class]]) {
                weakSelf.sources = [data objectForKey:@"botlist"];
                if (reload) {
                    [weakSelf.container cardReloadData];
                }
                
            }
        }
        else
        {
//            [[XYLogManager shareManager] addLogKey1:@"data" key2:@"error" content:@{@"type":@(0)} userInfo:[NSDictionary new] upload:NO];
        }
        for (UIButton * btn in self.controllers) {
            btn.hidden = NO;
        }
        [self.emptyView removeFromSuperview];
        
    } failure:^(NSError * error) {
        [CCLoadingHUD dismiss];
        if ( !self.sources || self.sources.count == 0) {
            [self setEmptyView];
        }
        NSLog(@"error----%@",error);
//        [[XYLogManager shareManager] addLogKey1:@"data" key2:@"overtime" content:@{@"type":@(0)} userInfo:[NSDictionary new] upload:NO];
    }];
}

-(void)notifitynotice:(id)sender{
    NSLog(@"%@",sender);
   
}
-(void)ObserverNotifity
{
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notifitynotice:) name:kPaymentSuccessNotificationName object:nil];
}


-(void)setEmptyView{
    
    for (UIButton * btn in self.controllers) {
        btn.hidden = YES;
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 271)/2.0, 50, 271, 186)];
    imageView.image = [UIImage imageNamed:@"blank"];
    [self.emptyView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, kScreenWidth, 20)];
    label.text = @"the current network is not connected";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"#B1B1B1"];
    label.font = [UIFont systemFontOfSize:14];
    [self.emptyView addSubview:label];
    
    UIButton * connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    connectBtn.frame = CGRectMake((kScreenWidth - 300)/2.0, CGRectGetMaxY(label.frame) + 50, 300, 50);
    connectBtn.backgroundColor = MainColor;
    [connectBtn setTitle:@"Reconnect the" forState:UIControlStateNormal];
    connectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    connectBtn.layer.cornerRadius = 25;
    [connectBtn addTarget:self action:@selector(connectData) forControlEvents:UIControlEventTouchUpInside];
    [self.emptyView addSubview:connectBtn];
}
-(void)connectData{
    
    [CCLoadingHUD show];
    [self loadData:YES];
}
-(UIView *)emptyView{
    if (!_emptyView) {
        CGFloat y = (kScreenHeight  - kNavBarHeight - kTabBarHeight - 400)/2.0;
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, 400)];
        [self.view addSubview:_emptyView];
    }
    return _emptyView;
}
-(void)showVideo{
    [self adVideowithlike];
}
-(void)showVIP{
    [self   showPaymentViewController];
}
-(void)setUpContainer{
    self.container = [[CCDragCardContainer alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight - kNavBarHeight - kTabBarHeight - 115)];
    self.container .dataSource = self;
    self.container .delegate = self;
    [self.view addSubview:self.container];
//    [self.container cardReloadData];
}
//加载下面喜欢不喜欢按钮
-(void)loadBottomButtons{
    NSArray *btnImageNames = @[@"不喜欢",@"恢复",@"喜欢"];
    NSArray *methodNames = @[@"dislikeButtonAction:",@"recoverButtonAction:",@"likeButtonAction:"];
    CGFloat originX = (kScreenWidth-75*3)/4.0;
    //    CGFloat originX = 60.0f;
    for (int index = 0;index <  btnImageNames.count; index++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:btnImageNames[index]] forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString(methodNames[index]) forControlEvents:UIControlEventTouchUpInside];
        
        [self.controllers addObject:btn];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(originX*(index +1)+index*(75), kScreenHeight - kNavBarHeight - kTabBarHeight - 115 + 10, 75, 75);
        
    }
    
}
#pragma mark - 导航栏按钮点击事件
- (void)menuAction:(UIBarButtonItem *)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)filterAction:(UIBarButtonItem *)sender {
    
    [kAppWindow addSubview:self.bgView];
    [kAppWindow addSubview:self.screenView];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.screenView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -ScrrenHeight);
        self.bgView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
}
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        
        UITapGestureRecognizer * closeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
        closeTap.delegate = self;
        [_bgView addGestureRecognizer:closeTap];
    }
    return _bgView;
}

-(CCReScreenView *)screenView{
    if (!_screenView) {
        _screenView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CCReScreenView class]) owner:self options:nil] lastObject];
        _screenView.frame = CGRectMake(0,kScreenHeight, kScreenWidth, ScrrenHeight);
        _screenView.layer.cornerRadius = 10;
        _screenView.clipsToBounds = YES;
        _screenView.delegate = self;
    }
    return _screenView;
}
#pragma mark ScrreenDelegate
-(void)screeenPassDicValue:(id)data{
    if (!data) {
        [self dismissView];
    }else{
        if ([data isKindOfClass:[NSDictionary class]]) {
            [self dismissView];
            [self.parameters addEntriesFromDictionary:data];
            [CCLoadingHUD show];
            
            [self.container cardReloadData];
            [self loadData:YES];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view == self.bgView ) {
        return YES;
    }
    return NO;
}
-(void)dismissView{
    //    [UIView animateWithDuration:0.4 animations:^{
    //        self.screenView.xy_y = kScreenHeight;
    //    } completion:^(BOOL finished) {
    //        [self.bgView removeFromSuperview];
    //        for (UIView * view in self.bgView.subviews) {
    //            [view removeFromSuperview];
    //        }
    //
    //    }];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.screenView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.screenView removeFromSuperview];
    }];
}
#pragma mark - 导航栏按钮
- (void)addxyNavigationButtonItems {
    //    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"筛选"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(filterAction:)];
    
    //    self.navigationItem.leftBarButtonItem = menuBtn;
    self.navigationItem.rightBarButtonItem = filterBtn;
}

#pragma mark -  YFLDragCardContainer  DataSource

- (NSInteger)numberOfRowsInXYLDragCardContainer:(CCDragCardContainer *)container
{
    return self.sources.count;
}

- (CCDragCardView *)dragViewContainer:(CCDragCardContainer *)container viewForRowsAtIndex:(NSInteger)index
{
    DDCardView *cardView = [[DDCardView alloc]initWithFrame:container.bounds];
    NSDictionary * item = self.sources[index];
    [cardView setPersonalImage:[[item safeObj:@"photo"] firstObject] name:[item safeObj:@"name"] withAge:[item safeObj:@"age"]];
    cardView.label.text = [NSString stringWithFormat:@"id---%@",[item safeObj:@"id"]];
    return cardView;
}

#pragma mark -  YFLDragCardContainer  Delegate

- (void)dragCardContainer:(CCDragCardContainer *)container didSelectRowAtIndex:(NSInteger)index
{
    NSLog(@"didSelectRowAtIndex :%ld",(long)index);
}

- (void)dragCardContainer:(CCDragCardContainer *)container dataSourceIsEmpty:(BOOL)isEmpty
{
    if (isEmpty) {
        [container  cardReloadData];
    }
}

- (BOOL)dragCardContainer:(CCDragCardContainer *)container canDragForCardView:(CCDragCardView *)cardView
{
    CCUserModel *useModel = [CCUserModel sharedUserModel];
    useModel.userphotos = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphoto"];
    if (useModel.userphotos.count==0) {
        [self showUploadView];
        return NO;
    }
    return YES;
}

- (void)dragCardContainer:(CCDragCardContainer *)container dargingForCardView:(CCDragCardView *)cardView direction:(ContainerDragDirection)direction widthRate:(float)widthRate  heightRate:(float)heightRate
{
    DDCardView *currentShowCardView = (DDCardView*)cardView;
    CGFloat scale = 1 + ((boundaryRation > fabs(widthRate) ? fabs(widthRate) : boundaryRation)) / 4;
    NSString  *scaleString =  [NSString stringWithFormat:@"%.2f",scale];
    NSNumber *number = [NSNumber numberWithFloat:scaleString.floatValue];
    direction = [number isEqual:@1] ? ContainerDragDefaults:direction;
    [currentShowCardView  setAnimationwithXYDriection:direction];
}

- (void)dragCardContainer:(CCDragCardContainer *)container dragDidFinshForDirection:(ContainerDragDirection)direction forCardView:(CCDragCardView *)cardView
{
    if (self.totldPage == self.pageNum) {
        return;
    }
    //喜欢
    if (direction == ContainerDragRight) {
        NSLog(@"disappear:%ld",(long)cardView.tag);
//        NSString *numberStr = [[NSUserDefaults standardUserDefaults] objectForKey:likedNumber];
//        NSInteger intnumber = [numberStr integerValue];
//        intnumber  = intnumber+1;
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)intnumber] forKey:likedNumber];
        
        [self sayHiMessage:cardView];
//        self.lastCardView = nil;
    }else if (direction == ContainerDragLeft){
        NSLog(@"disappear:%ld",(long)cardView.tag);
//        self.lastDragDirection = direction;
//        self.lastCardView = (DDCardView *)cardView;
//        self.lastCardView.isLiked = YES;
        
    }
    if ((long)cardView.tag  > CriSize) {
        [self loadData:NO];
    }
}

-(void)sayHiMessage:(CCDragCardView *)cardView{
    if (self.sources && self.sources.count > 0) {
        NSInteger index = cardView.tag;
//        [[XYLogManager shareManager] addLogKey1:@"hi" key2:@"click" content:@{@"type":@(0)} userInfo:[NSDictionary new] upload:YES];
        NSDictionary * dic = self.sources[index];
        NSString *botid = [dic safeObj:@"id"];
        int botidint = [botid intValue];
        NSString *lang = @"en";
        NSString *content = [[[CCmessageModel sharedClient] showbackmessage]filtrationSpecailCharactor];
        NSDictionary * dict = @{@"botid":@(botidint),@"lang":lang?:@"",@"content":content?:@"",@"contenttype":@1};
        NSArray * photos = [dic objectForKey:@"photo"];
        [[ChatManager sharedChatManager] chatSayHi:botid withContent:content withUserName:[dic safeObj:@"name"] withPhoto:photos.firstObject];
        [[AFNetAPIClient sharedClient] requestUrl:Sayhi cParameters:dict success:^(NSDictionary * _Nonnull requset) {
            if ([[requset objectForKey:@"code"] intValue]==1) {
                NSDictionary * data = [requset objectForKey:@"data"];
                if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"replyflag"] isEqual:@1]) {
                    NSInteger sencond = [[data objectForKey:@"replytime"] integerValue];
                    CCMessageItem * item = [[CCMessageItem alloc]init];
                    item.userId = botid;
                    item.userName = [dic safeObj:@"name"];
                    
                    NSInteger type = [[data objectForKey:@"contenttype"] integerValue];
                    item.msgType = type - 1;
                    if (type == 1) {
                        item.message = [[[data objectForKey:@"content"] safeObj:@"msg"]filtrationSpecailCharactor];
                    }else if (type == 2){
                        item.message = [[data objectForKey:@"content"] safeObj:@"photo"];
                    }else if (type == 3){
                        item.message = [NSString stringWithFormat:@"%@||%@",[[data objectForKey:@"content"] safeObj:@"videopreview"],[[data objectForKey:@"content"] safeObj:@"video"]];
                    }
                    
                    item.photo = photos.firstObject;
                    [((AppDelegate *)[UIApplication sharedApplication].delegate) registerNotification:sencond withMessageItem:item];
                    //                        [[ChatSendManager sharedInstance] senderMessage:item withAfterSecond:10];
                }
            }
        } failure:^(NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"There is no Internet" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}
-(void)dragCardContainer:(CCDragCardContainer *)container dragDisappearForDirection:(ContainerDragDirection)direction forCardView:(CCDragCardView *)cardView{
    [self.shadeView removeFromSuperview];
}
#pragma mark - Action Methods
-(void)recoverButtonAction:(UIButton *)sender{
}
//-(void)recoverImage{
//    [self.lastCardView recoverLikeAnimation];
//}
- (void)dislikeButtonAction:(UIButton*)sender
{
    [self.view.window addSubview:self.shadeView];
    [self.container removeXyCardViewForDirection:ContainerDragLeft];
    DDCardView * cardiView = (DDCardView *)[self.container getCurrentNeedShowCardView];
    [cardiView setAnimationwithXYDriection:ContainerDragLeft];
    
    [self xylogManagerDisliketype:@{@"type":@"1"}];
}
-(UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _shadeView;
}

-(void)showUploadView{
    
    CCPhotoView *alertView = [CCPhotoView new];
    [alertView withrepylClick:^(NSString *string) {
        NSLog(@"上传照片");
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor whiteColor];
        imagePickerVc.barItemTextColor = [UIColor blackColor];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowCameraLocation = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos.count!=0) {
                [[APIResult sharedClient] replyImgfrom:[photos firstObject]];
            }
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
}

- (void)likeButtonAction:(UIButton*)sender
{
    //先传照片
    CCUserModel *useModel = [CCUserModel sharedUserModel];
    useModel.userphotos = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphoto"];
    if (useModel.userphotos.count==0) {
        [self showUploadView];
    }
    else
    {
        [self.view.window addSubview:self.shadeView];
        [self.container removeXyCardViewForDirection:ContainerDragRight];
        DDCardView * cardiView = (DDCardView *)[self.container getCurrentNeedShowCardView];
        [cardiView setAnimationwithXYDriection:ContainerDragRight];
        [self xylogManagerLiketype:@{@"type":@"1"}];
    }
    
}
#pragma mark - OverRide Methods
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
//like 喜欢  0/1 0:滑动选择 1：点击选择
-(void)xylogManagerLiketype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"recommend" key2:@"like" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}
//dislike 不喜欢  0/1 0:滑动选择 1：点击选择
-(void)xylogManagerDisliketype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"recommend" key2:@"dislike" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}


@end
