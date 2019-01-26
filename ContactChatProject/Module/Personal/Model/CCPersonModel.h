//
//  CCPersonModel.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPersonModel : NSObject
@property (nonatomic , copy) NSString              * single;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , strong) NSMutableArray              * photos;
@property (nonatomic , assign) NSInteger              Newid;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * signature;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * horoscope;
@property (nonatomic , copy) NSString              * getuserinfo;
@property (nonatomic , copy) NSString              * wholikeme;
@end

NS_ASSUME_NONNULL_END
