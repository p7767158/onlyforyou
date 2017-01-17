//
//  HLOrderDB.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderDB.h"
#import "HLTableVersionDB.h"
#import "HLOrder.h"

static int const kTblVersionOrder = 1;

@implementation HLOrderDB

SYNTHESIZE_SINGLETON_FOR_CLASS(HLOrderDB);

- (void)initStore:(NSString *)baseUrl
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseUrl, kOrderDB];
    [self setDB:path];
    @weakify(self);
    [[HLTableVersionDB sharedHLTableVersionDB] getTblVersionForDB:kOrderDB finishBlock:^(NSDictionary *versions) {
        FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
        if ([db open]) {
            if (!versions || !versions[kOrderTbl] || (kTblVersionOrder > [versions[kOrderTbl] intValue])) {
                [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", kOrderTbl]];
                [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (oid integer primary key autoincrement, title varchar, detail varchar, money integer default 0, create_time mediumint, update_time mediumint)", kOrderTbl]];
                [[HLTableVersionDB sharedHLTableVersionDB] updateVersion:kTblVersionOrder forTbl:kOrderTbl inDB:kOrderDB];
            }
            [db close];
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            @strongify(self);
            [self run];
        });
    }];
}

- (void)create:(HLOrder *)order finish:(HLSuccessBlock)finishBlock
{
    [self doWrite:[NSString stringWithFormat:@"INSERT INTO %@ (title, detail, money, create_time, update_time) VALUES (:title, :detail, :money, :create_time, :update_time)", kOrderTbl]
       withParams:@{@"title":order.title, @"detail":order.detail, @"money":@(order.money), @"create_time":@(order.createTime), @"update_time":@(order.updateTime)}
      finishBlock:^(long long lastId) {
        finishBlock(lastId >= 0);
    }];
}

- (void)update:(HLOrder *)order finish:(HLSuccessBlock)finishBlock
{
    if (order.oid <= 0) {
        return;
    }
    [self doWrite:[NSString stringWithFormat:@"UPDATE %@ SET title=:title, detail=:detail, money=:money, update_time=:update_time WHERE oid=:oid", kOrderTbl] withParams:@{@"title":order.title, @"detail":order.detail, @"money":@(order.money), @"update_time":@(order.updateTime), @"oid":@(order.oid)} finishBlock:^(long long lastId) {
        finishBlock(lastId >= 0);
    }];
}

- (void)deleteWithOid:(long long)oid finish:(HLSuccessBlock)finishBlock
{
    if (oid <= 0) {
        return;
    }
    [self doWrite:[NSString stringWithFormat:@"DELETE FROM %@ WHERE oid=:oid", kOrderTbl] withParams:@{@"oid":@(oid)} finishBlock:^(long long lastId) {
        finishBlock(lastId >= 0);
    }];
}

- (void)getOrderList:(void(^)(NSArray *))finishBlock
{
    [self doRead:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY create_time DESC", kOrderTbl] withParams:@{} finishBlock:^(NSArray *res) {
        finishBlock(res);
    }];
}

- (void)getOrderSum:(void (^)(NSArray *))finishBlock
{
    [self doRead:[NSString stringWithFormat:@"SELECT SUM(money) FROM %@", kOrderTbl] withParams:@{} finishBlock:^(NSArray *res) {
        finishBlock(res);
    }];
}

@end
