//
//  HLGlobal.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/9.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HLSuccessBlock) (BOOL successs);

@interface HLGlobal : NSObject

+ (NSTimeInterval)currentTimestamp;

@end
