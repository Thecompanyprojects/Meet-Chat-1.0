//
//  AppDelegate+Extension.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@interface AppDelegate (Extension)
/** 根视图设置 */
- (void)setupRootViewControllerWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;
/** 第三方Sdks初始化设置 */
- (void)setupThirdSdkConfig;
@end

NS_ASSUME_NONNULL_END
