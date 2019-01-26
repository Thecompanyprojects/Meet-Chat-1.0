//
//  BaseViewController.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "BaseViewController.h"
#import <SafariServices/SafariServices.h>
#import "CCPhotoView.h"

typedef NS_ENUM (NSInteger, SubAdwhthType)   {
    
    SubvideoAdwithlike = 0,
    SubvideoAdwithalive = 1,
    SubvideoAdwithshake = 2,
    SubvideoAdwithbottle = 3,
    SubvideoAdwithsayhi = 4,
    SubvideoAdwithgetBottle = 5,
    SubvideoAdwithLikeRecall = 6  //喜欢撤回
};


@interface BaseViewController ()
@property (nonatomic,assign) SubAdwhthType videoType;
//@property (nonatomic, strong) XYAdObject *interstitialAdObj; /**< 插屏广告对象 */
@end

@implementation BaseViewController

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBackButtonItemText:NSLocalizedString(@"Back", nil)];
    
}

#pragma mark - 设置下一页的返回按钮样式
- (void)setBackButtonItemText:(NSString *)text {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    [backButton setTitle:text];
    self.navigationItem.backBarButtonItem = backButton;
}

#pragma mark - 将控制器从导航堆栈中移除
- (void)removeFromNavigationStack {
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [arrM removeObject:self];
    self.navigationController.viewControllers = arrM;
}

#pragma mark - 打开一个网页
- (void)pushWebViewController:(NSString *)url {
    SFSafariViewController *safariController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
    [self presentViewController:safariController animated:YES completion:nil];
}

#pragma mark - 是否允许侧滑返回
- (BOOL)backToPreviousByGesture {
    return YES;
}




#pragma mark - 弹出激励视频选择项目


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 是否需要上传头像

-(BOOL)isshouldUpload
{
    CCUserModel *useModel = [CCUserModel sharedUserModel];
    useModel.userphotos = [[NSUserDefaults standardUserDefaults] objectForKey:@"userphoto"];
    if (useModel.userphotos.count==0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    return NO;
}

#pragma mark - 一张照片上传

-(void)UploadthePhoto
{
    CCPhotoView *alertView = [CCPhotoView new];
    [alertView withrepylClick:^(NSString *string) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
        imagePickerVc.oKButtonTitleColorNormal = [UIColor whiteColor];
        imagePickerVc.barItemTextColor = [UIColor blackColor];
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowCameraLocation = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            if (photos.count!=0) {
                
                [[APIResult sharedClient] replyImgfrom:[photos firstObject]];
            }
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }];
}

#pragma mark - 导航栏下面的那条线消失

-(void)delNavLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list)
        {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
            {//10.0的系统字段不一样
                UIView *view = (UIView*)obj;
                for (id obj2 in view.subviews) {
                    
                    if ([obj2 isKindOfClass:[UIImageView class]])
                    {
                        
                        UIImageView *image =  (UIImageView*)obj2;
                        image.hidden = YES;
                    }
                }
            }
        }
    }
}



@end

