//
//  XYNetworkTools.h
//  XToolConstellationIOS
//
//  Created by 潘志 on 2018/10/18.
//  Copyright © 2018年 小叶科技. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYNetworkTools : NSObject

//网路请求参数加密
+ (NSDictionary *)handleParameter:(NSDictionary *)parameter;
//字符串转十六进制
+ (NSData *)stringToHexData:(NSString *)hexStr;
//十六进制转 字符串
+ (NSString *)hexStringFromData:(NSData *)myD;

@end

