//
//  CCloginnavController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCloginnavController.h"
#import "CCLoginViewController.h"
#import "CCLogupViewController.h"

@interface CCloginnavController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation CCloginnavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    // 设置全屏滑动返回
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    self.interactivePopGestureRecognizer.enabled = NO;
}

-(void)handleNavigationTransition:(UIPanGestureRecognizer *)pand
{
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isHideNav = ([viewController isKindOfClass:[CCLogupViewController class]] ||
                      [viewController isKindOfClass:[CCLoginViewController class]]);
    
    
    [self setNavigationBarHidden:isHideNav animated:YES];
}



@end
