//
//  AppDelegate+Extension.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppDelegate+Extension.h"

#import "BaseNavigationController.h"
#import "UITabBar+badge.h"


@implementation AppDelegate (Extension)

- (void)setupRootViewControllerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    
    // Window设置
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    // 主控制器视图
    self.tabBarController = [[CCTabbarController alloc] init];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
}
- (void)sharedWithController:(UIViewController *)controller {
    //分享的标题
    NSString *textToShare = NSLocalizedString(@"Share to Friends", nil);
    //分享的图片
    UIImage *imageToShare = [UIImage appIconImage];
    //分享的url
    NSString *url = kAppStoreUrl;
    NSURL *urlToShare = [NSURL URLWithString:url];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[textToShare,imageToShare, urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [controller presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"share completed");
            //分享 成功
        } else  {
            NSLog(@"share is cancled");
            //分享 取消
        }
    };
}

- (void)setupThirdSdkConfig {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.shouldResignOnTouchOutside = YES;
    
    
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@""]];
}

@end

