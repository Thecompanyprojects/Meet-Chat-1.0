//
//  CCConstellationJudge.h
//  ContactChatProject
//
//  Created by 王俊钢 on 2018/12/11.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCConstellationJudge : NSObject
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;
@end

NS_ASSUME_NONNULL_END
