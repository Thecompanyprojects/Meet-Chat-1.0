//
//  CCDragCardContainer.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCDragCardContainer.h"
#import "CCDragConfigure.h"
@interface CCDragCardContainer()<UIGestureRecognizerDelegate>
/** YFLDragCardView实例的集合 **/
@property (nonatomic,strong) NSMutableArray <CCDragCardView *> *cards;
/** 滑动方向 **/
@property (nonatomic,assign)  ContainerDragDirection direction;
/** 是否滑动 **/
@property (nonatomic,assign) BOOL isMoveIng;
/** 已加载个数 **/
@property (nonatomic,assign) NSInteger loadedIndex;
/** 记录第一个card的farme **/
@property (nonatomic,assign) CGRect firstCardFrame;
/** 记录最后一个card的frame **/
@property (nonatomic,assign) CGRect lastCardFrame;
/** 记录card的center **/
@property (nonatomic,assign) CGPoint cardCenter;
/** 记录最后一个card的transform **/
@property (nonatomic,assign) CGAffineTransform lastCardTransform;

@property (nonatomic,strong) CCDragConfigure *configure;

@property (nonatomic,strong)UIView * shadeView;

@end

@implementation CCDragCardContainer

#pragma mark - Init Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame configure:[self setDefaultsCardConfigures]];
}

- (instancetype)initWithFrame:(CGRect)frame configure:(CCDragConfigure*)configure
{
    self = [super initWithFrame:frame];
    if (self){
        [self initCardDataConfigure:configure];
    }
    return self;
}

#pragma mark - Private Methods
- (CCDragConfigure*)setDefaultsCardConfigures
{
    CCDragConfigure *configure = [[CCDragConfigure alloc]init];
    configure.visableCount = 3;
    configure.containerEdge = 20.0f;
    configure.cardEdge = 5.0f;
    configure.cardCornerRadius = 20.0f;
    configure.cardCornerBorderWidth = 0.25f;
    configure.cardBordColor = [UIColor colorWithRed:176.0f/255.0f green:176.0f/255.0f blue:176.0f/255.0f alpha:1];
    return configure;
}

- (void)initCardDataConfigure:(CCDragConfigure*)configure
{
    [self resetInitCardData];
    self.cards = [[NSMutableArray alloc]init];
    self.backgroundColor = [UIColor whiteColor];
    self.configure = !configure ? [self setDefaultsCardConfigures] : configure;
}

- (void)resetInitCardData
{
    self.loadedIndex = 0;
    self.direction = ContainerDragDefaults;
    self.isMoveIng = NO;
    
}//重置数据(为了二次调用reload)


- (void)addSubViews
{
    NSInteger sum = [self.dataSource numberOfRowsInXYLDragCardContainer:self];
    NSInteger preLoadViewCount = (sum <= self.configure.visableCount) ? sum : self.configure.visableCount;
    //预防越界
    if (self.loadedIndex <  sum)
    {
        // 当手势滑动，加载第四个，最多创建4个。不存在内存warning。(手势停止，滑动的view没消失，需要干掉多创建的+1)
        for (NSInteger i = self.cards.count; i < (self.isMoveIng ? preLoadViewCount+1:preLoadViewCount); i++)
        {
            CCDragCardView *cardView = [self.dataSource dragViewContainer:self viewForRowsAtIndex:self.loadedIndex];
            cardView.frame = CGRectMake(self.configure.containerEdge, self.configure.containerEdge, self.frame.size.width-2*self.configure.containerEdge, self.frame.size.height-2*(self.configure.containerEdge+self.configure.cardEdge));
            [cardView setConfigure:self.configure];
            [cardView XYDragCardViewLayoutSubviews];
            [self recordCardFrame:cardView];
            cardView.tag = self.loadedIndex;
            [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CardhandleTapGesture:)]];
            UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(CardhandlePanGesture:)];
            pan.delegate = self;
            [cardView addGestureRecognizer:pan];
            cardView.userInteractionEnabled = NO;
            [self addSubview:cardView];
            [self sendSubviewToBack:cardView];
            [self.cards addObject:cardView];
            self.loadedIndex += 1;
        }
    }
    
    CCDragCardView * cardView = [self.subviews lastObject];
    if ([cardView isKindOfClass:[CCDragCardView class]]) {
        cardView.userInteractionEnabled = YES;
    }
    
}//添加子视图

- (void)resetLayoutCardSubviews
{
    //动画时允许用户交流，比如触摸 | 时间曲线函数，缓入缓出，中间快
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        if ([self.delegate respondsToSelector:@selector(dragCardContainer:dargingForCardView:direction:widthRate:heightRate:)]) {
            [self.delegate dragCardContainer:self dargingForCardView:self.cards.firstObject direction:self.direction widthRate:0 heightRate:0];
        }
        
        for (int i = 0; i < self.cards.count; i++){
            CCDragCardView *cardView = [self.cards objectAtIndex:i];
            cardView.transform = CGAffineTransformIdentity;
            CGRect frame = self.firstCardFrame;
            
            switch (i) {
                case 0:
                    cardView.frame = frame;
                    cardView.userInteractionEnabled = YES;
                    break;
                case 1:
                {
                    frame.origin.y = frame.origin.y+self.configure.cardEdge;
                    cardView.frame = frame;
                    cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, secondCardScale, 1);
                }
                    break;
                case 2:
                {
                    frame.origin.y = frame.origin.y+2*self.configure.cardEdge;
                    cardView.frame = frame;
                    cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, thirdCardScale, 1);
                    if (CGRectIsEmpty(self.lastCardFrame)) {
                        self.lastCardFrame = frame;
                        self.lastCardTransform = cardView.transform;
                    }
                }
                    break;
                default:
                    break;
            }
            
            cardView.originTransForm = cardView.transform;
            
        }
        
    } completion:^(BOOL finished) {
        
        BOOL isEmpty = self.cards.count == 0 ? YES : NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardContainer:dataSourceIsEmpty:)]) {
            [self.delegate dragCardContainer:self dataSourceIsEmpty:isEmpty];
        }
    }];
    
    
}//布局子视图

- (void)recordCardFrame:(CCDragCardView *)cardView
{
    if (self.loadedIndex >= 3){
        
        cardView.frame = self.lastCardFrame;
        
    }else{
        
        CGRect frame = cardView.frame;
        if (CGRectIsEmpty(self.firstCardFrame)){
            self.firstCardFrame = frame;
            self.cardCenter = cardView.center;
        }
    }
}

- (void)moveIngCardStatusChange:(float)scale
{
    //如果正在移动，添加第四个
    if (!self.isMoveIng) {
        
        self.isMoveIng = YES;
        [self addSubViews];
        
    }else{
        
        //第四个加载完，立马改变没作用在手势上其他cardview的scale
        scale = fabsf(scale) >= boundaryRation ? boundaryRation : fabsf(scale);
        CGFloat transFormtxPoor = (secondCardScale-thirdCardScale)/(boundaryRation/scale);
        CGFloat frameYPoor = self.configure.cardEdge/(boundaryRation/scale); // frame y差值
        
        for (int index = 1; index < self.cards.count ; index++) {
            CCDragCardView *cardView = (CCDragCardView *)self.cards[index];
            switch (index) {
                case 1:
                {
                    //CGAffineTransformScale实现以一个已经存在的形变为基准,在x轴方向上缩放x倍,在y轴方向上缩放y倍
                    CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, transFormtxPoor + secondCardScale, 1);
                    //CGAffineTransformTranslate实现以一个已经存在的形变为基准,在x轴方向上平移x单位,在y轴方向上平移y单位
                    CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -frameYPoor);
                    cardView.transform = translate;
                }
                    break;
                    
                case 2:
                {
                    CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, transFormtxPoor + thirdCardScale, 1);
                    CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -frameYPoor);
                    cardView.transform = translate;
                    
                }
                    break;
                    
                case 3:
                {
                    cardView.transform = self.lastCardTransform;
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        
    }
    
}//移动卡片

- (void)panGesturemMoveCardFinishOrCancle:(CCDragCardView*)cardView direction:(ContainerDragDirection)direction scale:(float)scale isDisappear:(BOOL)isDisappear
{
    if (!isDisappear) {
        
        //干掉多创建的第四个.重置标量
        if (self.isMoveIng && self.cards.count > self.configure.visableCount) {
            
            CCDragCardView *lastView = (CCDragCardView *)self.cards.lastObject;
            [lastView removeFromSuperview];
            [self.cards removeObject:lastView];
            self.loadedIndex = lastView.tag;
        }
        self.isMoveIng = NO;
        [self resetLayoutCardSubviews];
    }else{
        
        if ([self.delegate respondsToSelector:@selector(dragCardContainer:dragDidFinshForDirection:forCardView:)]) {
            
            [self.delegate dragCardContainer:self dragDidFinshForDirection:self.direction forCardView:cardView];
            
        }
        
        NSInteger flag = (direction == ContainerDragLeft?-1:2);
        
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            cardView.center = CGPointMake(flag*kScreenWidth, flag*kScreenHeight/scale+self.cardCenter.y);
            
        } completion:^(BOOL finished) {
            
            [cardView removeFromSuperview];
            
        }];
        
        [self.cards removeObject:cardView];
        self.isMoveIng = NO;
        [self resetLayoutCardSubviews];
        
        
    }
    
}//手势结束

#pragma mark - Public Methods
- (void)cardReloadData
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInXYLDragCardContainer:)] && [self.dataSource respondsToSelector:@selector(dragViewContainer:viewForRowsAtIndex:)]) {
        
        [self resetInitCardData];
        
        //刷新关键代码
        for (CCDragCardView * view in self.subviews) {
            if([view isKindOfClass:[CCDragCardView class]]){
                [view removeFromSuperview];
            }
        }
        [self.cards removeAllObjects];
        
        [self addSubViews];
        
        [self resetLayoutCardSubviews];
        
    }else{
        
        NSAssert(self.dataSource, @"check dataSource and dataSource Methods!");
    }
    
}

- (CCDragCardView *)getCurrentNeedShowCardView
{
    return self.cards.firstObject;
}

- (NSInteger)getCurrentNeedShowCardViewIndex
{
    return self.cards.firstObject.tag;
}

//添加卡片
-(void)addCardViewForDragDirection:(ContainerDragDirection)direction withCardView:(CCDragCardView *)cardView{
    
    if (self.isMoveIng) return;
    [self.window addSubview:self.shadeView];
    CGPoint cardCenter = CGPointZero;
    NSInteger flag = 0;
    switch (direction) {
            
        case ContainerDragLeft:
        {  cardCenter = CGPointMake(-kScreenWidth/2.0, self.cardCenter.y);
            flag = -1;
        }
            break;
        case ContainerDragRight:
        {
            cardCenter = CGPointMake(kScreenWidth*1.5, self.cardCenter.y);
            flag = 1;
            
        }
            break;
        default:
            break;
    }
    
    //    KKLDragCardView *currentShowCardView = self.cards.firstObject;
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
        cardView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
        cardView.center = cardCenter;
    } completion:^(BOOL finished) {
        [self addSubview: cardView];
        [self.cards insertObject:cardView atIndex:0];
        
        if (self.cards.count > 3) {
            CCDragCardView * tCardView = [self.cards objectAtIndex:3];
            [tCardView removeFromSuperview];
            [self.cards removeObject:tCardView];
        }
        [self addSubViews];
        [self resetLayoutCardSubviews];
        [self.shadeView removeFromSuperview];
        
    }];
}
//移除卡片
- (void)removeXyCardViewForDirection:(ContainerDragDirection)direction
{
    if (self.isMoveIng) return;
    CGPoint cardCenter = CGPointZero;
    NSInteger flag = 0;
    switch (direction) {
            
        case ContainerDragLeft:
        {  cardCenter = CGPointMake(-kScreenWidth/2.0, self.cardCenter.y);
            flag = -1;
        }
            break;
        case ContainerDragRight:
        {
            cardCenter = CGPointMake(kScreenWidth*1.5, self.cardCenter.y);
            flag = 1;
            
        }
            break;
        default:
            break;
    }
    
    CCDragCardView *currentShowCardView = self.cards.firstObject;
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
        currentShowCardView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
        currentShowCardView.center = cardCenter;
    } completion:^(BOOL finished) {
        [currentShowCardView removeFromSuperview];
        [self.cards removeObject:currentShowCardView];
        [self addSubViews];
        [self resetLayoutCardSubviews];
        
        //卡片滑动结束的代理(可用户发送数据请求)
        if ([self.delegate respondsToSelector:@selector(dragCardContainer:dragDisappearForDirection:forCardView:)]) {
            
            [self.delegate dragCardContainer:self dragDisappearForDirection:direction forCardView:currentShowCardView];
        }
        
    }];
    
    //卡片滑动结束的代理(可用户发送数据请求)
    if ([self.delegate respondsToSelector:@selector(dragCardContainer:dragDidFinshForDirection:forCardView:)]) {
        
        [self.delegate dragCardContainer:self dragDidFinshForDirection:direction forCardView:currentShowCardView];
    }
    
    
}//手动点击移除

#pragma mark - Action Methods
- (void)CardhandleTapGesture:(UITapGestureRecognizer*)tap
{
    if ([self.delegate respondsToSelector:@selector(dragCardContainer:didSelectRowAtIndex:)])
    {
        [self.delegate dragCardContainer:self didSelectRowAtIndex:tap.view.tag];
    }
    
}//单击手势

-(UIView *)shadeView{
    if (!_shadeView) {
        _shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _shadeView;
}

- (void)CardhandlePanGesture:(UIPanGestureRecognizer*)pan
{
    
    BOOL canEdit = YES;
    if ([self.delegate respondsToSelector:@selector(dragCardContainer:canDragForCardView:)]) {
        canEdit = [self.delegate dragCardContainer:self canDragForCardView:(CCDragCardView*)pan.view];
    }
    
    if (canEdit) {
        [self.window addSubview:self.shadeView];
        if (pan.state == UIGestureRecognizerStateBegan){
            // TO DO
        }else if (pan.state == UIGestureRecognizerStateChanged){
            
            CCDragCardView *cardView = (CCDragCardView *)pan.view;
            
            //以自身的左上角为原点；每次移动后，原点都置0；计算的是相对于上一个位置的偏移；
            CGPoint point = [pan translationInView:self];
            cardView.center = CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
            
            //当angle为正值时,逆时针旋转坐标系统,反之顺时针旋转坐标系统
            cardView.transform = CGAffineTransformRotate(cardView.originTransForm, (pan.view.center.x-self.cardCenter.x)/self.cardCenter.x*(M_PI_4/12));
            
            [pan setTranslation:CGPointZero inView:self]; // 设置坐标原点位上次的坐标
            
            if ([self.delegate respondsToSelector:@selector(dragCardContainer:dargingForCardView:direction:widthRate:heightRate:)]) {
                
                //计算横向滑动比例 >0 向右  <0 向左
                float horizionSliderRate = (pan.view.center.x-self.cardCenter.x)/self.cardCenter.x;
                float verticalSliderRate = (pan.view.center.y-self.cardCenter.y)/self.cardCenter.y;
                
                //正在滑动，需要创建第四个。
                [self moveIngCardStatusChange:horizionSliderRate];
                
                if (horizionSliderRate > 0) {
                    self.direction = ContainerDragRight;
                }else if (horizionSliderRate < 0){
                    self.direction = ContainerDragLeft;
                }else{
                    self.direction = ContainerDragDefaults;
                }
                
                [self.delegate dragCardContainer:self dargingForCardView:cardView direction:self.direction widthRate:horizionSliderRate heightRate:verticalSliderRate];
            }
        }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateEnded){
            
            [self.shadeView removeFromSuperview];
            //还原，或者消失
            float horizionSliderRate = (pan.view.center.x-self.cardCenter.x)/self.cardCenter.x;
            float moveY = (pan.view.center.y-self.cardCenter.y);
            float moveX = (pan.view.center.x-self.cardCenter.x);
            [self panGesturemMoveCardFinishOrCancle:(CCDragCardView*)pan.view direction:self.direction scale:moveX/moveY isDisappear:fabs(horizionSliderRate)>boundaryRation];
            
            if (self.direction == ContainerDragRight) {
                [self cardlogManagerLiketype:@{@"type":@"0"}];
            }else if (self.direction == ContainerDragLeft){
                [self cardlogManagerDisliketype:@{@"type":@"0"}];
            }
        }
        
    }
}
//like 喜欢  0/1 0:滑动选择 1：点击选择
-(void)cardlogManagerLiketype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"recommend" key2:@"like" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}
//dislike 不喜欢  0/1 0:滑动选择 1：点击选择
-(void)cardlogManagerDisliketype:(NSDictionary *)keyDic
{
//    [[XYLogManager shareManager] addLogKey1:@"recommend" key2:@"dislike" content:keyDic userInfo:[NSDictionary new] upload:YES];
    
}

@end
