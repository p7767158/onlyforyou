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

- (void)create:(HLOrder *)order finish:(HLSuccessBlock)finishBlock;
- (void)update:(HLOrder *)order finish:(HLSuccessBlock)finishBlock;
- (void)deleteWithOid:(long long)oid finish:(HLSuccessBlock)finishBlock;
- (void)getOrderList:(void(^)(NSArray *))finishBlock;
- (void)getOrderSum:(void(^)(NSArray *))finishBlock;

@end
