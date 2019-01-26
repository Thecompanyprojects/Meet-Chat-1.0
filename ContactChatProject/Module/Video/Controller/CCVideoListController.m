//
//  CCVideoListController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCVideoListController.h"
#import "CCVideoCell.h"
#import "CCVideoPlayController.h"
#import "CCVideolistModel.h"


@interface CCVideoListController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,myTabVdelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

static NSString *videoidendtify = @"videoidendtify";

@implementation CCVideoListController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Video";
    [self CClogManager];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"000000"];
    [self.view addSubview:self.collectionView];
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(CCloadNewData)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(CCloadMoreData)];
    [self CCloadNewData];
//    [self.collectionView.mj_header beginRefreshing];
}

-(void)CCloadNewData
{
    [self.dataSource removeAllObjects];
    self.dataSource = [NSMutableArray array];
    NSDictionary *dic = @{@"size":@(8)};
    [[AFNetAPIClient sharedClient] requestUrl:filtratevideo cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CCVideolistModel class] json:requset[@"data"][@"botlist"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.collectionView reloadData];
//        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError * _Nonnull error) {
//        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)CCloadMoreData
{
    NSDictionary *dic = @{@"size":@(8)};
    [[AFNetAPIClient sharedClient] requestUrl:filtratevideo cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSMutableArray *data = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[CCVideolistModel class] json:requset[@"data"][@"botlist"]]];
            [self.dataSource addObjectsFromArray:data];
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 20, 20);
        [_collectionView registerClass:[CCVideoCell class] forCellWithReuseIdentifier:videoidendtify];
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


#pragma mark -UICollectionViewDataSource&&UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCVideoCell *cell = (CCVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:videoidendtify forIndexPath:indexPath];
    cell.delegate = self;
    if (self.dataSource.count!=0) {
        cell.model = self.dataSource[indexPath.item];
    }
    return cell;
}

//定义每个Cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(158*KWIDTH,192);
    return size;
}

-(void)myTabVClick:(UICollectionViewCell *)cell
{
    NSIndexPath *index =  [self.collectionView indexPathForCell:cell];
    CCVideolistModel *model = self.dataSource[index.item];
    CCVideoPlayController *VC = [CCVideoPlayController new];
    [VC returnPeopleindex:^(BOOL isSayHi) {
        if (isSayHi) {
            model.isSayHi = YES;
        }
    }];
    VC.type = RobotvideofromList;
    VC.model = model;
    VC.issayHi = model.isSayHi;
    if (model.video.count!=0) {
        NSString *VideoUrl = [[model.video firstObject] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        VC.videoUrl = VideoUrl;
        [self.navigationController pushViewController:VC animated:YES];
    }
  
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CCVideolistModel *model = self.dataSource[indexPath.item];
    CCVideoPlayController *VC = [CCVideoPlayController new];
    [VC returnPeopleindex:^(BOOL isSayHi) {
        if (isSayHi) {
            model.isSayHi = YES;
        }
    }];
    VC.type = RobotvideofromList;
    VC.model = model;
    VC.issayHi = model.isSayHi;
    if (model.video.count!=0) {
        NSString *VideoUrl = [[model.video firstObject] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        VC.videoUrl = VideoUrl;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark - 打点上报

-(void)CClogManager
{
//    [[XYLogManager shareManager] addLogKey1:@"video" key2:@"show" content:[NSDictionary new] userInfo:[NSDictionary new] upload:YES];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaymentSuccessNotificationName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
