//
//  CCDiscoverViewController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCDiscoverViewController.h"
#import "CCDiscoverheaderView.h"
#import "CCDiscoverModel.h"
#import "CCdiscoverCell.h"
#import "CCShakeViewController.h"
#import "CCBottleViewController.h"
#import "CCPeopleViewController.h"
#import "CCVideoListController.h"
#import "CCRobitinfoViewController.h"

@interface CCDiscoverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,myTabVdelegate>
{
    int PageSize;
}
@property (nonatomic,strong) CCDiscoverheaderView *headerView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSDictionary *parameters;
@end

#define ScrrenHeight  330.0

static NSString *discoverIdentfity = @"discoverIdentfity";

@implementation CCDiscoverViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    PageSize = 12;
    int idint = [[CCUserModel sharedUserModel].userId intValue];
    self.parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"sex":@"f",
                                                                      @"age":@[@18,@40],
                                                                      @"active":@(4),
                                                                      @"size":@(PageSize),
                                                                      @"id":@(idint)}];

    [self.view addSubview:self.collectionView];
    [self CCloadNewData];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(CCloadMoreData)];
    
}


#pragma mark -loadData

-(void)CCloadNewData
{
    self.dataSource = [NSMutableArray array];
    [[AFNetAPIClient sharedClient] requestUrl:SocicalchatFiltrate cParameters:self.parameters success:^(NSDictionary * _Nonnull requset) {
        
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CCDiscoverModel class] json:requset[@"data"][@"botlist"]]];
            NSMutableArray *dataArray = [NSMutableArray new];
            [dataArray addObjectsFromArray:data];
            [self.dataSource addObjectsFromArray:data];
        }
        else
        {
//            [[XYLogManager shareManager] addLogKey1:@"data" key2:@"error" content:@{@"type":@(1)} userInfo:[NSDictionary new] upload:NO];
        }

        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
     
//        [[XYLogManager shareManager] addLogKey1:@"data" key2:@"overtime" content:@{@"type":@(1)} userInfo:[NSDictionary new] upload:NO];
    }];
}

-(void)CCloadMoreData
{
    [[AFNetAPIClient sharedClient] requestUrl:SocicalchatFiltrate cParameters:self.parameters success:^(NSDictionary * _Nonnull requset) {
        
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CCDiscoverModel class] json:requset[@"data"][@"botlist"]]];
            NSMutableArray *dataArray = [NSMutableArray new];
            [dataArray addObjectsFromArray:data];
            [self.dataSource addObjectsFromArray:data];
        }
        else
        {
//            [[XYLogManager shareManager] addLogKey1:@"data" key2:@"error" content:@{@"type":@(1)} userInfo:[NSDictionary new] upload:NO];
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
        [self.collectionView.mj_footer endRefreshing];
//        [[XYLogManager shareManager] addLogKey1:@"data" key2:@"overtime" content:@{@"type":@(1)} userInfo:[NSDictionary new] upload:NO];
    }];
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 18*KWIDTH, 30, 18*KWIDTH);
        [_collectionView registerClass:[CCdiscoverCell class] forCellWithReuseIdentifier:discoverIdentfity];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}


#pragma mark -UICollectionViewDelegate&&UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CCdiscoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:discoverIdentfity forIndexPath:indexPath];
    if (self.dataSource.count!=0) {
        [cell newsetModel:self.dataSource[indexPath.item]];
    }
    cell.delegate = self;
    return cell;
}

//定义每个Cell的大小

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(105*KWIDTH,155);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCDiscoverModel *model = self.dataSource[indexPath.item];
    CCRobitinfoViewController *VC = [CCRobitinfoViewController new];
    VC.type = RobotinfofromDis;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    VC.model = model;
    VC.returnPeopleBlock = ^(BOOL peopleIndex) {
        model.issayHi = peopleIndex;
        [self.collectionView reloadData];
        
    };
    [self CCrobitPushlogManager];
    [self.navigationController pushViewController:VC animated:YES];

}


#pragma mark - Mydelegate

-(void)myTabVClick:(UICollectionViewCell *)cell
{
    if ([self isshouldUpload]) {
        [self UploadthePhoto];
        return;
    }
    NSIndexPath *index = [self.collectionView indexPathForCell:cell];
    CCDiscoverModel *model = self.dataSource[index.item];
    model.issayHi = YES;
    NSString *botid = model.Newid;
    int botidint = [botid intValue];
    NSString *lang = @"en";
    NSString *content = [[[CCmessageModel sharedClient] showbackmessage] filtrationSpecailCharactor];
    NSDictionary *dic = @{@"botid":@(botidint),@"lang":lang?:@"",@"content":content?:@"",@"contenttype":@1};
    
    [[ChatManager sharedChatManager] chatSayHi:botid withContent:content withUserName:model.name withPhoto:model.photo.firstObject];
    
    CCMessageItem * item = [[CCMessageItem alloc]init];
    item.userName = model.name;
    item.message =content;
    item.photo = model.photo.firstObject;
    item.userId = model.Newid;
    item.createDate = [NSDate date].timeIntervalSince1970 * 1000;
    CCMessageDetailController * messageDetail = [[CCMessageDetailController alloc]initWithNibName:NSStringFromClass([CCMessageDetailController class]) bundle:nil];
    item.sendUserId = [CCUserModel sharedUserModel].userId;

    messageDetail.msgItem = item;
    messageDetail.closeBlock = ^{
        [self.collectionView reloadData];
    };
    
    UIBarButtonItem *items = [[UIBarButtonItem alloc] initWithTitle:@"Discover" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = items;
    [self.navigationController pushViewController:messageDetail animated:YES];

    [[AFNetAPIClient sharedClient] requestUrl:Sayhi cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSDictionary * data = [requset objectForKey:@"data"];
            if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"replyflag"] isEqual:@1]) {
                NSInteger sencond = [[data objectForKey:@"replytime"] integerValue];
                NSInteger type = [[data objectForKey:@"contenttype"] integerValue];
                item.msgType = type - 1;
                if (type == 1) {
                    item.message = [[[data objectForKey:@"content"] safeObj:@"msg"]filtrationSpecailCharactor];
                }else if (type == 2){
                    item.message = [[data objectForKey:@"content"] safeObj:@"photo"];
                }else if (type == 3){
                    item.message = [NSString stringWithFormat:@"%@||%@",[[data objectForKey:@"content"] safeObj:@"videopreview"],[[data objectForKey:@"content"] safeObj:@"video"]];
                }
                [((AppDelegate *)[UIApplication sharedApplication].delegate) registerNotification:sencond withMessageItem:item];
            }
            model.issayHi = YES;
            [self.collectionView reloadData];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - headClick

-(void)chooseClick0
{
    CCShakeViewController *VC = [CCShakeViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)chooseClick1
{
    CCBottleViewController *VC = [CCBottleViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)chooseClick2
{
    CCPeopleViewController *VC = [CCPeopleViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)chooseClick3
{
    CCVideoListController *VC = [CCVideoListController new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 打点上传

-(void)CCrobitPushlogManager
{
//    [[XYLogManager shareManager] addLogKey1:@"personal_details" key2:@"show" content:@{@"type":@(0)} userInfo:[NSDictionary new] upload:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
