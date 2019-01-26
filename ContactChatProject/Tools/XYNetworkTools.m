//
//  XYNetworkTools.m
//  XToolConstellationIOS
//
//  Created by 潘志 on 2018/10/18.
//  Copyright © 2018年 小叶科技. All rights reserved.
//

#import "XYNetworkTools.h"
#import "NSString+AdBlowfish.h"

@implementation XYNetworkTools

+(NSDictionary *)handleParameter:(NSDictionary *)parameter{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if (!param.allKeys.count) {
        return nil;
    }
    for (NSString* key in param.allKeys) {
        
        id value = [param objectForKey:key];
        
        if ([value isKindOfClass:NSDictionary.class]){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            value = str;
        }else if (![value isKindOfClass:NSString.class]){
            //            NSAssert(false, @"这个参数要转换为str类型，不然下一行加密方法就会崩溃");
            value = [NSString stringWithFormat:@"%@",value];
        }
        
        NSString *value_bf_base64 = [value xy_blowFishEncodingWithKey:xy_BlowFishKey];
        NSData *value_bf_data = [[NSData alloc] initWithBase64EncodedString:value_bf_base64 options:0];
        NSString *value_bf_hex_str = [XYNetworkTools hexStringFromData:value_bf_data];
        
        [param setObject:value_bf_hex_str forKey:key];
    }
    return param.copy;
}

//十六进制转 字符串
+ (NSString *)hexStringFromData:(NSData *)myD{
    Byte *bytes = (Byte *)[myD bytes];
    NSMutableString *hexStr=[NSMutableString new];
    @autoreleasepool{
        for(int i=0;i<[myD length];i++){
            NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
            if([newHexStr length]==1){
                [hexStr appendString:[NSString stringWithFormat:@"0%@",newHexStr]];
            }else{
                [hexStr appendString:[NSString stringWithFormat:@"%@",newHexStr]];
            }
        }
    }
    return hexStr;
}

//字符串转十六进制
+ (NSData *)stringToHexData:(NSString *)hexStr{
    unsigned long len = [hexStr length] / 2;    // Target length
    unsigned char *buf = malloc(len);
    unsigned char *whole_byte = buf;
    char byte_chars[3] = {'\0','\0','\0'};
    
    int i;
    for (i=0; i < [hexStr length] / 2; i++) {
        byte_chars[0] = [hexStr characterAtIndex:i*2];
        byte_chars[1] = [hexStr characterAtIndex:i*2+1];
        *whole_byte = strtol(byte_chars, NULL, 16);
        whole_byte++;
    }
    
    NSData *data = [NSData dataWithBytes:buf length:len];
    free( buf );
    return data;
}

@end
