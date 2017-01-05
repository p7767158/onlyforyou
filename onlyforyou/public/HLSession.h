//
//  HLSession.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSession : NSObject

+ (HLSession *)sharedHLSession;
- (void)restore;

@end
