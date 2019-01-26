//
//  AppDelegate.h
//  ContactChatProject
//
//  Created by maxin on 2018/12/7.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTabbarController.h"
//#import "SqliteManager.h"
//#import "ChatSendManager.h"
#import "CCMessageItem.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) MMDrawerController * drawerController;
@property (nonatomic,strong)CCTabbarController *tabBarController;
-(void)registerNotification:(NSInteger )alerTime withMessageItem:(CCMessageItem *)item;

@end

