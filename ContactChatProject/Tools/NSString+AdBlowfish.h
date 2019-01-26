//
//  NSString+Blowfish.h
//  XToolWhiteNoiseIOS
//
//  Created by 许亚光 on 2018/8/22.
//  Copyright © 2018年 小叶科技. All rights reserved.
//

/*****************************************
 *  BlowFish 使用说明:
 *                  加密模式：ECB
 *                  填充模式：PKCS5Padding
 *                  输出：base64
 *                  字符集：UTF8
 *****************************************/

#define xy_BlowFishKey            @"2GIMeS%aJ%"

#import <Foundation/Foundation.h>

@interface NSString (AdBlowfish)

/** BlowFish 加密:返回的是Base64的字符串 */
- (NSString *)xy_blowFishEncodingWithKey:(NSString *)pkey;

/** BlowFish 解密:需要是Base64的字符串调用,返回的是解密结果 */
- (NSString *)xy_blowFishDecodingWithKey:(NSString *)pkey;

@end
