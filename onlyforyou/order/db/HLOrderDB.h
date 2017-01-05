//
//  HLOrderDB.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLBaseDB.h"

static NSString * const kOrderDB = @"order.db";
static NSString * const kOrderTbl = @"hl_order";

@class HLOrder;
@interface HLOrderDB : HLBaseDB

+ (HLOrderDB *)sharedHLOrderDB;
- (void)initStore:(NSString *)baseUrl;

@end
