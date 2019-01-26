//
//  CCBaseItem.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCBaseItem : NSObject
/**
 通过字典来创建一个模型
 
 @param item 字典(可以是NSDictionary、NSData、NSString)
 @return 新建的对象
 */
- (instancetype)initWithItem:(id)item;
@end

NS_ASSUME_NONNULL_END
