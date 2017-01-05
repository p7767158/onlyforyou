//
//  HLTableVersionDB.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLBaseDB.h"

static NSString * const kVersionDB = @"dbversion.db";
static NSString * const kVersionTbl = @"version";

@interface HLTableVersionDB : HLBaseDB

+ (HLTableVersionDB *)sharedHLTableVersionDB;
- (void)getTblVersionForDB:(NSString *)db finishBlock:(void(^)(NSDictionary *))finishBlock;
- (void)getVersionForTbl:(NSString *)tbl inDB:(NSString *)db finishBlock:(void(^)(int version))finishBlock;
- (void)updateVersion:(int)version forTbl:(NSString *)tbl inDB:(NSString *)db;
- (void)initStore:(NSString *)baseUrl;

@end
