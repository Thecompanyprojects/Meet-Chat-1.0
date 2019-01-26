//
//  XYNetworkRequest.h
//  XToolConstellationIOS
//
//  Created by 潘志 on 2018/10/18.
//  Copyright © 2018年 小叶科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

@interface XYNetworkRequest : AFHTTPSessionManager

-(void)requestUrl:(NSString *)url Parameters:(NSDictionary *)parameters success:(void (^)(NSDictionary *response))success failure:(void (^)(NSError *error))failure;

@end


