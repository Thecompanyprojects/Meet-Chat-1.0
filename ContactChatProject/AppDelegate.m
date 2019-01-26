//
//  AppDelegate.m
//  ContactChatProject
//
//  Created by maxin on 2018/12/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppDelegate.h"
#import "CCLoginViewController.h"
#import "AppDelegate+Extension.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "CCloginnavController.h"
#import <UserNotifications/UserNotifications.h>
//#import <XTOOLAPP_LIBRARY/XYDeepLinkTools.h>
//#import <Firebase.h>
#import "XYPushManager.h"
//#import <XTOOLAPP_LIBRARY/XYAdEventManager.h>
#import "Interface.h"
#import "CCPeopleViewController.h"
#import "CCMessageListViewController.h"
#import "ChatSendManager.h"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,GIDSignInDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bugly startWithAppId:BuglyAppID];
    CGSize size = [@"What you name is Gaga wohh heh heh edge hheheheheh" contentSizeWithWidth:202 font:[UIFont systemFontOfSize:14] lineSpacing:0];
    NSLog(@"size---%f",size.height);
//    [[XYLogManager shareManager]configurationStatisticsUrl:[ServerIP stringByAppendingString:statistics_log_url] crashUrl:[ServerIP stringByAppendingString:crash_log_url]];
//    [[XYLogManager shareManager] uploadAllLog];

    NSUserDefaults *userdefat = [NSUserDefaults standardUserDefaults];
    NSString *str = [userdefat objectForKey:@"isLogin"];
    
    if ([str isEqualToString:@"1"]) {
        [self setupRootViewControllerWithApplication:application launchOptions:launchOptions];
        
        CCUserModel *model = [CCUserModel sharedUserModel];
        model.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        model.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        model.refreshtoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshtoken"];
        model.sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sex"];
        [[APIResult sharedClient] getUserInfo];
    }
    else
    {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window setBackgroundColor:[UIColor whiteColor]];
        CCLoginViewController *baseView = [[CCLoginViewController alloc]init];
        CCloginnavController *nav = [[CCloginnavController alloc] initWithRootViewController:baseView];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    
    [self setupThirdSdkConfig];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKSettings setAppID:@"335925157163320"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [GIDSignIn sharedInstance].clientID = @"691173424333-mra25fq6lpccalnuvlaep0dujlbf98pl.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    
//    [FIRApp configure];
//    [FIRDynamicLinks performDiagnosticsWithCompletion:nil];

     [self requestNotificationCenter];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

-(void)requestNotificationCenter{
    
    if (@available(iOS 10.0, *)){
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
        }];
        
        //注册远程通知
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else{
        // ios8后，需要添加这个注册，才能得到授权
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            
        }
    }
}

//使用 UNNotification 本地通知
-(void)registerNotification:(NSInteger )alerTime withMessageItem:(CCMessageItem *)item{
    NSDictionary *  message =  [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
    long long createTime = [NSDate date].timeIntervalSince1970 * 1000 + alerTime* 1000;
    NSDictionary * userDict = @{@"content":item.message,
                                @"id":item.userId,
                                @"name":item.userName,
                                @"photo":item.photo,
                                @"creatTime":[NSString stringWithFormat:@"%lld",createTime],
                                @"updateDate":[NSString stringWithFormat:@"%lld",item.updateDate],
                                @"type":@(item.msgType)
                                };
    if (message == nil) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:userDict forKey:[NSString stringWithFormat:@"%lld",createTime]];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"message"];
    }else{
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:message];
        [dict setValue:userDict forKey:[NSString stringWithFormat:@"%lld",createTime]];
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"message"];
    }
    if (@available(iOS 10.0, *)){
        // 使用 UNUserNotificationCenter 来管理通知
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc] init];
        content.title = item.userName;
        content.body = item.message;
        content.userInfo = userDict;
        content.sound = [UNNotificationSound defaultSound];
        
        // 在 alertTime 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:alerTime repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%lld",createTime]
                                                                              content:content trigger:trigger];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"error----%@",error);

        }];
        
    }else{
        // ios8后，需要添加这个注册，才能得到授
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        // 设置触发通知的时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alerTime];
        NSLog(@"fireDate=%@",fireDate);
        
        notification.fireDate = fireDate;
        // 时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复的间隔
        notification.repeatInterval = kCFCalendarUnitSecond;
        
        // 通知内容
        notification.alertTitle = item.userName;
        notification.alertBody = item.message;
        // 通知被触发时播放的声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 通知参数
        notification.userInfo = userDict;
        
        // ios8后，需要添加这个注册，才能得到授权
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = NSCalendarUnitSecond;
        } else {
            // 通知重复提示的单位，可以是天、周、月
            notification.repeatInterval = NSCalendarUnitSecond;
        }
        
        // 执行通知注册
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    }
    
}

#pragma mark - UNUserNotificationCenterDelegate

//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    //1. 处理通知
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"消息回调userInfo----%@",userInfo);
    
    //远程推送
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
       
        
    }else{
        
        if([userInfo objectForKey:@"rate_push"]){
            completionHandler(UNNotificationPresentationOptionAlert);
        }else{
            //本地推送
            NSString * creatime = [userInfo objectForKey:@"creatTime"];
            NSDictionary * message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            if ([[message objectForKey:creatime] isKindOfClass:[NSDictionary class]]) {
                
                CCMessageItem * item = [[CCMessageItem alloc]init];
                item.msgType = [[userInfo objectForKey:@"type"] integerValue];
                item.userId = [userInfo objectForKey:@"id"];
                item.photo = [userInfo objectForKey:@"photo"];
                item.userName = [userInfo objectForKey:@"name"];
                item.message = [userInfo objectForKey:@"content"];
                item.sendUserId = item.userId;
                item.createDate = [[userInfo objectForKey:@"creatTime"] longLongValue];
                item.updateDate = [[userInfo objectForKey:@"updateDate"] longLongValue];
                [[ChatSendManager sharedInstance] senderMessage:item withAfterSecond:0];
                
                NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:message];
                [dict removeObjectForKey:creatime];
                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"message"];
            }
        }
    }
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    BOOL googleDeepLink = [[XYDeepLinkTools sharedInstance]deepLinkGoogleSettingWithUrl:url urlBlock:^(NSString * _Nonnull url) {
//
//    }];
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];

    return handled ;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
//    BOOL googleDeepLink = [[XYDeepLinkTools sharedInstance]deepLinkGoogleSettingWithUrl:url urlBlock:^(NSString * _Nonnull url) {
//
//    }];
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation];
    return handled;
//    return handled || googleDeepLink;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [XYPushManager registerDeviceToken:deviceToken];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSDictionary * message = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:message];
    [message enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key = %@ and obj = %@", key, obj);
        long long dateStamp = [NSDate date].timeIntervalSince1970 * 1000;
        long long keyDateStamp = [key longLongValue];
        if (dateStamp > keyDateStamp) {
            CCMessageItem * item = [[CCMessageItem alloc]init];
            item.userId = [obj objectForKey:@"id"];
            item.photo = [obj objectForKey:@"photo"];
            item.userName = [obj objectForKey:@"name"];
            item.message = [obj objectForKey:@"content"];
            item.createDate = [[obj objectForKey:@"creatTime"] longLongValue];
            item.updateDate = [[obj objectForKey:@"updateDate"] longLongValue];
            item.msgType = [[obj objectForKey:@"type"] integerValue];
            item.sendUserId = item.userId;
            [[ChatSendManager sharedInstance] senderMessage:item withAfterSecond:0];
            [dict removeObjectForKey:key];
        }
        
    }];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"message"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
}

@end
