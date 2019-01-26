//
//  ConfigMacro.h
//  ContactChatProject
//
//  Created by 杨帅 on 2018/12/10.
//  Copyright © 2018 pan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ConfigMacro_h
#define ConfigMacro_h


@protocol CellPassDelegate <NSObject>

-(void)cellPassIndexPath:(NSIndexPath *)indexpath withObject:(id)object  withCell:(id)cell;
-(void)cellPassIndexPath:(NSIndexPath *)indexpath withObject:(id)object;
@end

#define FontPingFangR(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]
#define FontPingFangU(x) [UIFont fontWithName:@"PingFangSC-Ultralight" size:x]
#define FontPingFangL(x) [UIFont fontWithName:@"PingFangSC-Light" size:x]

#endif /* ConfigMacro_h */
