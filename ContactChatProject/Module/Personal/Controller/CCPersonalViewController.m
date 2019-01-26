//
//  CCPersonalViewController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCPersonalViewController.h"
#import "SDCycleScrollView.h"
#import "CCPersonalCell0.h"
#import "CCPersonalCell2.h"
#import "CCPersonalCell3.h"
#import "CCSettingViewController.h"
#import "CCEditorViewController.h"

@interface CCPersonalViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) CCPersonModel *personModel;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,assign) BOOL isPush;
@end

static NSString *personalidentfity0 = @"personalidentfity0";
static NSString *personalidentfity1 = @"personalidentfity1";
static NSString *personalidentfity2 = @"personalidentfity2";
static NSString *personalidentfity3 = @"personalidentfity3";


@implementation CCPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Mine";
    
    [self addSubscribeButton];
    
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    self.table.tableHeaderView = self.cycleScrollView;
    [self CCgetUserInfo];
    [self logManager];
    
}

- (void)addSubscribeButton{
    UIBarButtonItem *editorBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Editor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(editorClick:)];
    
    self.navigationItem.rightBarButtonItem = editorBtn;
}

-(void)CCgetUserInfo
{
    self.isPush = NO;
    NSString *newId = [CCUserModel sharedUserModel].userId;
    NSDictionary *dic = @{@"id":newId?:@""};
    [self logManagersayHi];
    self.personModel = [[CCPersonModel alloc] init];
    [[AFNetAPIClient sharedClient] requestUrl:GETUserInfo cParameters:dic success:^(NSDictionary * _Nonnull requset) {
        if ([[requset objectForKey:@"code"] intValue]==1) {
            NSDictionary *data = [requset objectForKey:@"data"];
            self.personModel = [CCPersonModel yy_modelWithDictionary:data];
            self.cycleScrollView.imageURLStringsGroup = self.personModel.photos;
            self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
            self.cycleScrollView.layer.masksToBounds = YES;
            [self.table reloadData];
            [[NSUserDefaults standardUserDefaults] setObject:self.personModel.photos forKey:@"userphoto"];
            [self.table reloadData];
            self.isPush = YES;
        }
        else
        {
//            [[XYLogManager shareManager] addLogKey1:@"data" key2:@"error" content:@{@"type":@(7)} userInfo:[NSDictionary new] upload:NO];
        }
    } failure:^(NSError * _Nonnull error) {
//        [[XYLogManager shareManager] addLogKey1:@"data" key2:@"overtime" content:@{@"type":@(7)} userInfo:[NSDictionary new] upload:NO];
    }];
}

#pragma mark - getters

-(UITableView *)table
{
    if(!_table)
    {
        _table = [[UITableView alloc] init];
        _table.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight-kNavBarHeight);
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

-(SDCycleScrollView *)cycleScrollView
{
    if(!_cycleScrollView)
    {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth) delegate:self placeholderImage:[UIImage imageNamed:@"backImg2"]];
        _cycleScrollView.autoScrollTimeInterval = 5;
    }
    return _cycleScrollView;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        
    }
    return _footView;
}


#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2) {
        return 4;
    }
    else
    {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        CCPersonalCell0 *cell = [tableView dequeueReusableCellWithIdentifier:personalidentfity0];
        cell = [[CCPersonalCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalidentfity0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.personModel;
        return cell;
    }
    if (indexPath.section==1) {
        CCPersonalCell2 *cell = [tableView dequeueReusableCellWithIdentifier:personalidentfity1];
        cell = [[CCPersonalCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalidentfity1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+200, 0.f, 0.f);
        return cell;
    }
    if (indexPath.section==2) {
        CCPersonalCell3 *cell = [tableView dequeueReusableCellWithIdentifier:personalidentfity2];
        cell = [[CCPersonalCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalidentfity2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.typeImg.image = [UIImage imageNamed:@"address"];
                if (self.personModel.city.length==0) {
                    cell.contentLab.text = @"Unfilled";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"E1E1E1"];
                }
                else
                {
                    cell.contentLab.text = self.personModel.city?:@"";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
                }
                
                cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+200, 0.f, 0.f);
                break;
            case 1:
                cell.typeImg.image = [UIImage imageNamed:@"constellation"];
                if (self.personModel.horoscope.length==0) {
                    cell.contentLab.text = @"Unfilled";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"E1E1E1"];
                }
                else
                {
                    cell.contentLab.text = self.personModel.horoscope?:@"";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
                }
                cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+200, 0.f, 0.f);
                break;
            case 2:
                cell.typeImg.image = [UIImage imageNamed:@"feelings"];
                if (self.personModel.single.length!=0) {
                    if ([self.personModel.single isEqualToString:@"1"]) {
                        cell.contentLab.text = @"Single";
                        cell.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
                    }
                    else
                    {
                        cell.contentLab.text = @"Live alone";
                        cell.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
                    }
                }
                else
                {
                    cell.contentLab.text = @"Unfilled";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"E1E1E1"];
                }
                cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+200, 0.f, 0.f);
                break;
            case 3:
                cell.typeImg.image = [UIImage imageNamed:@"birthday"];
                if (self.personModel.birthday.length==0) {
                    cell.contentLab.text = @"Unfilled";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"E1E1E1"];
                }
                else
                {
                    cell.contentLab.text = self.personModel.birthday?:@"";
                    cell.contentLab.textColor = [UIColor colorWithHexString:@"333333"];
                }
                break;
            default:
                break;
        }
        return cell;
    }
    
    if (indexPath.section==3) {
        CCPersonalCell3 *cell = [tableView dequeueReusableCellWithIdentifier:personalidentfity3];
        cell = [[CCPersonalCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personalidentfity3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.typeImg.image = [UIImage imageNamed:@"setting"];
        cell.contentLab.text = @"Set up";
        cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width+200, 0.f, 0.f);
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 65;
    }
    if (indexPath.section==1) {
        return 45;
    }
    if (indexPath.section==2) {
        return 50;
    }
    if (indexPath.section==3) {
        return 45;
    }
    return 0.01f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        CCSettingViewController *vc = [CCSettingViewController new];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Profile" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)editorClick:(UIBarButtonItem *)sender
{
    if (self.isPush) {
        CCEditorViewController *vc = [CCEditorViewController new];
        vc.personModel = self.personModel;
        [vc returnText:^(NSString *showText) {
            [self CCgetUserInfo];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self CCgetUserInfo];
    }
}


#pragma mark - 打点上传

-(void)logManager
{
//    [[XYLogManager shareManager] addLogKey1:@"profile" key2:@"show" content:[NSDictionary new] userInfo:[NSDictionary new] upload:YES];
    
}

-(void)logManagersayHi
{
//    [[XYLogManager shareManager] addLogKey1:@"hi" key2:@"click" content:@{@"type":@"1"} userInfo:[NSDictionary new] upload:YES];
}

@end
