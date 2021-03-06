//
//  DCFHttpManager.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import "XYNetworkRequest.h"
#import "XYNetworkRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCFHttpManager : XYNetworkRequest
+ (instancetype)sharedClient;
-(void)refreshTokensuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
