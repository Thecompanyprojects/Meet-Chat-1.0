//
//  CCEditorheaderView.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/11.
//  Copyright © 2018 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEditorimageView.h"
@class CCPersonModel;
NS_ASSUME_NONNULL_BEGIN

@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(NSString *)typeStr;

@end
@interface CCEditorheaderView : UIView
@property (nonatomic,strong) CCEditorimageView *imgView0;
@property (nonatomic,strong) CCEditorimageView *imgView1;
@property (nonatomic,strong) CCEditorimageView *imgView2;
@property (nonatomic,strong) CCEditorimageView *imgView3;
@property (nonatomic,strong) CCEditorimageView *imgView4;
@property (nonatomic,strong) CCEditorimageView *imgView5;
-(void)setheader:(CCPersonModel *)model;
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
NS_ASSUME_NONNULL_END
