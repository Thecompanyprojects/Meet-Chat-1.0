//
//  CCSendMsgCell.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCSendMsgCell.h"
#import "CCMessageItem.h"
#import "NSString+SKYExtension.h"
#import <UIImageView+WebCache.h>
#import "MyImageView.h"

@interface CCSendMsgCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UIImageView *contentBgImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBgLeading;
@property (weak, nonatomic) IBOutlet MyImageView * contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView * playIcon;
@property (weak, nonatomic) IBOutlet UIProgressView * progressView;
@property (strong,nonatomic)NSTimer * timer;
@property (strong,nonatomic)NSString * nameKey;
@property (weak, nonatomic)IBOutlet UIActivityIndicatorView * activityView;
@property (weak, nonatomic)IBOutlet UIButton * sendErrorBtn;
@end

@implementation CCSendMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentBgImgV.image = [self getPopImg];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDidFire:)];
    [self.contentBgImgV addGestureRecognizer:longPressGestureRecognizer];
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    self.effectView.effect = effect;
    //    self.effectView.backgroundColor = [UIColor redColor];
    
    
    self.activityView.hidden = YES;
    self.contentImageView.layer.cornerRadius = 5;
    self.contentImageView.clipsToBounds = YES;
    [self.contentImageView addTarget:self action:@selector(btnClick)];
    
    self.progressView.layer.cornerRadius = 2;
    self.progressView.clipsToBounds = YES;
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if([CCUserModel sharedUserModel].userphotos && [CCUserModel sharedUserModel].userphotos.count > 0){
        [self.headImgV sd_setImageWithURL:[NSURL URLWithString:[CCUserModel sharedUserModel].userphotos.firstObject] placeholderImage:[UIImage imageNamed:@"head"]];
    }else{
        [self.headImgV setImage:[UIImage imageNamed:@"head"]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)btnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPassIndexPath:withObject:withCell:)]) {
        [self.delegate cellPassIndexPath:self.indexPath withObject:self.contentImageView withCell:self];
    }
}
-(IBAction)reSendMessage:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPassIndexPath:withObject:)]) {
        self.sendErrorBtn.hidden = YES;
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
        [self.delegate cellPassIndexPath:self.indexPath withObject:self.msgItem];
    }
}
- (void)setContentMsg:(CCMessageItem *)msgItem {
    
    self.msgItem = msgItem;
    if (msgItem.msgType == 0) {
        self.contentLabel.text = msgItem.message;
        CGFloat maxWidth = SCREEN_MIN_LENGTH - 8 - 16  - 50 - 36 - 16 - 4;
        if ([msgItem.message contentHaveOneLinesWithWidth:maxWidth font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] lineSpacing:0]) {
            CGSize contentSize = [msgItem.message contentSizeWithWidth:maxWidth font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] lineSpacing:0];
            CGFloat contentWidth = ceil(contentSize.width);
            //            if (contentWidth < 30) {
            //                contentWidth = 30;
            //            }
            self.contentBgLeading.constant = SCREEN_MIN_LENGTH - contentWidth - 8 - 16  - 50 - 36 - 16 - 4 + 30;
        } else {
            self.contentBgLeading.constant = 50;
        }
        self.contentBgImgV.hidden = NO;
        self.playIcon.hidden = YES;
        self.contentImageView.hidden = YES;
        self.progressView.hidden = YES;
    }
}
- (UIImage*) getVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
    
}
//读取图片
-(UIImage *)getDocumentImagePath:(NSString *)path{
    NSString *aPath3=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),path];
    UIImage *imgFromUrl3=[[UIImage alloc]initWithContentsOfFile:aPath3];
    return imgFromUrl3;
}
- (UIImage *)getPopImg {
    UIImage *image = [UIImage imageNamed:@"SenderBkg"];
    return [image stretchableImageWithLeftCapWidth:10 topCapHeight:30];
}

//长按cell
- (void)longPressGestureDidFire:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGRect rect = self.contentBgImgV.frame;
        UIMenuController *menu = [UIMenuController sharedMenuController];
        // 定义菜单
        UIMenuItem *a = [[UIMenuItem alloc] initWithTitle:@"copy"
                                                   action:@selector(aAction)];
        //        UIMenuItem *b = [[UIMenuItem alloc] initWithTitle:@"转发"
        //                                                   action:@selector(bAction)];
        //        UIMenuItem *c = [[UIMenuItem alloc] initWithTitle:@"删除"
        //                                                   action:@selector(cAction)];
        //        menu.menuItems = @[a,b,c];
        menu.menuItems = @[a];
        [menu setTargetRect:rect inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(aAction) || action == @selector(bAction) || action == @selector(cAction)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)aAction{
    NSLog(@"--aAction--");
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.contentLabel.text;
}

- (void)bAction{
    NSLog(@"--bAction--");
}

- (void)cAction{
    NSLog(@"--aAction--");
}

@end
