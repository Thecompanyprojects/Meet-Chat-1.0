//
//  AFNetAPIClient.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

//#import "XYNetworkRequest.h"
#import "XYNetworkRequest.h"
#import <AFHTTPSessionManager.h>
NS_ASSUME_NONNULL_BEGIN

@interface AFNetAPIClient : XYNetworkRequest
+ (instancetype)sharedClient;
-(void)requestUrl:(NSString *)url cParameters:(NSDictionary *)parameters  success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
@end

NS_ASSUME_NONNULL_END
