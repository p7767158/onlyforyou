//
//  HLBaseDB.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@class FMResultSet;
@interface HLBaseDB : NSObject

typedef void (^ReadFinishBlock)(NSArray *res);
typedef void (^WriteFinishBlock)(long long lastId);

- (void)setDB:(NSString *)path;
- (void)run;
- (void)doRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block;
- (void)doSyncRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block;
- (void)doWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block;
- (void)doSyncWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block;

@end
