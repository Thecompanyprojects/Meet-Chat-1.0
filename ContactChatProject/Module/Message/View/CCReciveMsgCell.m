//
//  CCReciveMsgCell.m
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "CCReciveMsgCell.h"
#import "CCMessageItem.h"
#import "NSString+SKYExtension.h"
#import "MyImageView.h"
#import <UIImageView+WebCache.h>
#import "YYWebImage.h"
#import "NSString+SKYExtension.h"


@interface CCReciveMsgCell ()

@property (weak, nonatomic) IBOutlet MyImageView *headImgV;
@property (weak, nonatomic) IBOutlet UIImageView *contentBgImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBgTrailing;
@property (weak, nonatomic) IBOutlet MyImageView * contentImageView;
@property (weak, nonatomic) IBOutlet UIImageView * playIcon;
@property (strong, nonatomic) UIVisualEffectView * effectView;
@property (strong, nonatomic)CCMessageItem * msgItem;
@property (weak, nonatomic) IBOutlet UIProgressView * progressView;

@end

@implementation CCReciveMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentBgImgV.image = [self getPopImg];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDidFire:)];
    [self.contentBgImgV addGestureRecognizer:longPressGestureRecognizer];
    
    [self.headImgV addTarget:self action:@selector(inforClick)];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.vipView.bounds byRoundingCorners: UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.vipView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.vipView.layer.mask = maskLayer;
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.effectView.alpha = 1.0;
    self.effectView.frame = CGRectMake(0, 0, MMessageImageSizeWidth , MMessageImageSizeWidth * 262/220.0 + 5);
    [self.contentImageView addSubview:self.effectView];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    UITapGestureRecognizer *tapGesturRecognizer1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick)];
    [self.contentImageView addGestureRecognizer:tapGesturRecognizer1];
    [self.contentBgImgV addGestureRecognizer:tapGesturRecognizer];
    
    self.contentImageView.layer.cornerRadius = 5;
    self.contentImageView.clipsToBounds = YES;
    [self.contentImageView addTarget:self action:@selector(btnClick)];
    
    
    self.progressView.layer.cornerRadius = 2;
    self.progressView.clipsToBounds = YES;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setContentMsg:(CCMessageItem *)msgItem {
    self.msgItem = msgItem;
    if (msgItem.msgType == 0) {
        
        self.contentLabel.text = msgItem.message;
        self.vipView.hidden = YES;
       
        CGFloat maxWidth = SCREEN_MIN_LENGTH - 8 - 16  - 50 - 36 - 16 - 4;
        if ([msgItem.message contentHaveOneLinesWithWidth:maxWidth font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] lineSpacing:0]) {
            CGSize contentSize = [msgItem.message contentSizeWithWidth:maxWidth font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] lineSpacing:0];
            CGFloat contentWidth = ceil(contentSize.width);
            if (contentWidth < 30) {
                contentWidth = 30;
            }
            self.contentBgTrailing.constant = SCREEN_MIN_LENGTH - contentWidth - 8 - 16  - 50 - 36 - 16 - 4 + 30;
        } else {
            self.contentBgTrailing.constant = 50;
        }
        self.contentBgImgV.hidden = NO;
        self.playIcon.hidden = YES;
        self.contentImageView.hidden = YES;
        self.progressView.hidden = YES;
        
    }
}
-(void)inforClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPassIndexPath:withObject:)]) {
        [self.delegate cellPassIndexPath:self.indexPath withObject:self.contentImageView];
    }
}

-(void)btnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellPassIndexPath:withObject:withCell:)]) {
        [self.delegate cellPassIndexPath:self.indexPath withObject:self.contentImageView withCell:self];
    }
}
- (void)setHeadImg:(NSString *)imgUrlStr {
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
}

- (UIImage *)getPopImg {
    UIImage *image = [UIImage imageNamed:@"ReceiverBkg"];
    return [image stretchableImageWithLeftCapWidth:40 topCapHeight:30];
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

