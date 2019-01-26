//
//  CCMessageListViewController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCMessageListViewController.h"
#import "CCMessageItem.h"
#import "CCMessageCell.h"
#import "CCMessageDetailController.h"
#import "SqliteManager.h"
#import "ChatSendManager.h"
#import "ChatManager.h"
#import "NSString+SKYExtension.h"

static CGFloat CHooseBarHieght = 50.0;
@interface CCMessageListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UIButton *_selectBtn;
}
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray *msgMuArray;
@property (nonatomic,strong)NSMutableArray*deleteArray;
@end

static NSString *const kCellID = @"MessageCellID";

@implementation CCMessageListViewController






-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataSource];
    [self logManager];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageTab" object:nil];
}
//加载刷新数据
-(void)loadDataSource{
    
    NSString * listDbName = [NSString stringWithFormat:@"%@_list",[NSString stringWithFormat:@"%@",[CCUserModel sharedUserModel].userId]];
    [[SqliteManager sharedInstance] queryChatLogTableWithType:DBChatType_Private sessionID:listDbName userInfo:nil fuzzyUserInfo:nil complete:^(BOOL success, id obj) {
        NSLog(@"obj---%@",obj);
        self.msgMuArray = obj;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //            self.msgMuArray = [NSMutableArray arrayWithArray:[[HomeViewModel new] loadMessages]];
            
            //按照时间先后顺序排序
            [self.msgMuArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return  ((CCMessageItem *)obj1).createDate < ((CCMessageItem *)obj2).createDate;
            }];
            
            //置顶排序
            [self.msgMuArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return  ((CCMessageItem *)obj1).updateDate < ((CCMessageItem *)obj2).updateDate;
            }];
            
            //置顶按照实际排序排序
            [self.msgMuArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return  ((CCMessageItem *)obj1).updateDate &&  ((CCMessageItem *)obj2).updateDate && ((CCMessageItem *)obj1).createDate < ((CCMessageItem *)obj2).createDate;
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight - kNavBarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // 允许在编辑模式下进行多选操作
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    self.msgMuArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CCMessageCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    [self setSearchView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataSource) name:@"MessageListLoad" object:nil];
    
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"dingyue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(subscribe)];
    
}

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
}
- (void)subscribe{
//    [[XYLogManager shareManager] addLogKey1:@"premium" key2:@"entrance" content:@{@"result":@(5)} userInfo:nil upload:YES];
    [self showPaymentViewController];
}
- (void)setSearchView {
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.definesPresentationContext = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgMuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    CCMessageItem *item = self.msgMuArray[indexPath.row];
    cell.tintColor = [UIColor colorWithHexString:@"#F8438B"];
    cell.selectedBackgroundView = self.tableView.isEditing?[UIView new]:nil;
    [cell setMessageContent:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCMessageItem *item = self.msgMuArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CCMessageDetailController * messageDetail = [[CCMessageDetailController alloc]initWithNibName:NSStringFromClass([CCMessageDetailController class]) bundle:nil];
    messageDetail.msgItem = item;
    [self.navigationController pushViewController:messageDetail animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //从选中中取消
    
    if (self.tableView.isEditing == YES) {
        CCMessageItem *item = self.msgMuArray[indexPath.row];
        [self.deleteArray removeObject:item];
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.msgMuArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * sessionId = [NSString stringWithFormat:@"%@_list",[NSString stringWithFormat:@"%@",[CCUserModel sharedUserModel].userId]];
    CCMessageItem * item = self.msgMuArray[indexPath.row];
    NSString * content = [item.message stringByReplacingOccurrencesOfString:@"'" withString:@"\'\'"];
    item.message = content;
    
    NSString * sessionId1 = [NSString stringWithFormat:@"%@_%@",[CCUserModel sharedUserModel].userId,item.userId];
    // 添加一个删除按钮
    UITableViewRowAction * deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self deleteChatList:sessionId withItem:item];
        [self deleteChatDetailData:sessionId1 withItem:item];
        [self deleteChatDetail:sessionId1];
        
        [self.msgMuArray removeObjectAtIndex:indexPath.row];
        NSArray *indexPaths = @[indexPath];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [[ChatManager sharedChatManager] cornerMarkZero:item.userId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageTab" object:nil];
        
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#ff3b32"];
    
    NSString * title = NSLocalizedString(@"stack", nil);
    if (item.updateDate > 0) {
        title  = NSLocalizedString(@"canel stack", nil);
    }
    
    // 置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:title handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        if (item.updateDate > 0) {
            item.updateDate = 0;
        }else{
            item.updateDate = [NSDate date].timeIntervalSince1970 * 1000;
        }
        [[SqliteManager sharedInstance] updateOneChatLogWithType:DBChatType_Private sessionID:sessionId aChatLog:item updateItems:nil complete:^(BOOL success, id obj) {
            NSLog(@"obj---%@",obj);
        }];
        
        [self loadDataSource];
    }];
    topRowAction.backgroundColor = [UIColor colorWithHexString:@"#c7c6cb"];
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction];
    
}

-(void)deleteChatList:(NSString *)sessionId withItem:(CCMessageItem *)item{
    [[SqliteManager sharedInstance] deleteOneChatLogWithType:DBChatType_Private sessionID:sessionId msgID:item.userId complete:^(BOOL success, id obj) {
    }];
}
-(void)deleteChatDetail:(NSString *)sessionId{
    [[SqliteManager sharedInstance] deleteChatLogTableWithType:DBChatType_Private sessionID:sessionId complete:^(BOOL success, id obj) {
        NSLog(@"deleteSucess---%d",success);
    }];
}
-(void)deleteChatDetailData:(NSString *)sessionId withItem:(CCMessageItem *)item{
    [[SqliteManager sharedInstance] queryChatLogTableWithType:DBChatType_Private sessionID:sessionId userInfo:nil fuzzyUserInfo:nil complete:^(BOOL success, id obj) {
        for (CCMessageItem * item in obj) {
            if ([item.userId integerValue] == [[CCUserModel sharedUserModel].userId integerValue]) {
                NSString * file = [NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),item.message];
                if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
                    [NSString removeItemAtPath:file error:nil];
                }
                
            }
        }
    }];
}

-(void)Manage:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    if (self.tableView.isEditing) {
        [self.deleteArray removeAllObjects];
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.xy_height = self.tableView.isEditing?kScreenHeight - kTabBarHeight - kNavBarHeight - CHooseBarHieght:kScreenHeight - kTabBarHeight - kNavBarHeight;
        
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    
    
    
}

-(void)logManager
{
//    [[XYLogManager shareManager] addLogKey1:@"message" key2:@"show" content:@{@"type":@"0"} userInfo:[NSDictionary new] upload:YES];
}

@end
