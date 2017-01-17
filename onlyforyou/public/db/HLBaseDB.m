//
//  HLBaseDB.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLBaseDB.h"

@interface HLBaseDB ()

@property (nonatomic, strong) FMDatabase *readDB;
@property (nonatomic, strong) FMDatabase *writeDB;
@property (nonatomic, strong) dispatch_queue_t dbReadQueue;
@property (nonatomic, strong) dispatch_queue_t dbWriteQueue;
@property (nonatomic, copy) NSString *path;

@end

@implementation HLBaseDB

- (void)setDB:(NSString *)path
{
    _path = path;
    _readDB = [FMDatabase databaseWithPath:_path];
    _writeDB = [FMDatabase databaseWithPath:_path];
}

- (void)run
{
    _dbReadQueue = dispatch_queue_create("com.zhh.dbReadQueue", NULL);
    _dbWriteQueue = dispatch_queue_create("com.zhh.dbWriteQueue", NULL);
}

- (void)doRead:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(ReadFinishBlock)block
{
    dispatch_async(_dbReadQueue, ^{
        [_readDB open];
        FMResultSet *res = [_readDB executeQuery:sql withParameterDictionary:dictParams];
        NSMutableArray *ret = @[].mutableCopy;
        while ([res next]) {
            [ret addObject:[res resultDictionary]];
        }
        [_readDB close];
        block(ret);
    });
}

- (NSArray *)doSyncRead:(NSString *)sql withParams:(NSDictionary *)dictParams
{
    FMDatabase *db = [[FMDatabase alloc] initWithPath:_path];
    [db open];
    FMResultSet *res = [db executeQuery:sql withParameterDictionary:dictParams];
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    while ([res next]) {
        [ret addObject:[res resultDictionary]];
    }
    [db close];
    return ret;
}

- (void)doWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block
{
    dispatch_async(_dbWriteQueue, ^{
        long long lastId;
        [_writeDB open];
        if ([_writeDB executeUpdate:sql withParameterDictionary:dictParams]) {
            lastId = _writeDB.lastInsertRowId;
        } else {
            lastId = -_writeDB.lastErrorCode;
        }
        [_writeDB close];
        block(lastId);
    });
}

- (void)doSyncWrite:(NSString *)sql withParams:(NSDictionary *)dictParams finishBlock:(WriteFinishBlock)block
{
    long long lastId;
    FMDatabase *db = [[FMDatabase alloc] initWithPath:_path];
    [db open];
    if ([db executeUpdate:sql withParameterDictionary:dictParams]) {
        lastId = [db lastInsertRowId];
    } else {
        lastId = -db.lastErrorCode;
    }
    [db close];
    if (block) {
        block(lastId);
    }
}

@end
