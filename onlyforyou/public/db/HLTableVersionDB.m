//
//  HLTableVersionDB.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLTableVersionDB.h"

@interface HLTableVersionDB ()

@property (nonatomic, copy) NSString *path;

@end

@implementation HLTableVersionDB

SYNTHESIZE_SINGLETON_FOR_CLASS(HLTableVersionDB);

- (void)initStore:(NSString *)baseUrl
{
    _path = [NSString stringWithFormat:@"%@/%@", baseUrl, kVersionDB];
    FMDatabase *dbh = [[FMDatabase alloc] initWithPath:_path];
    if ([dbh open]) {
        [dbh executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer primary key autoincrement, db varchar, tbl varchar, version integer)", kVersionTbl]];
        [dbh executeUpdate:[NSString stringWithFormat:@"CREATE UNIQUE INDEX IF NOT EXISTS idx_db_tbl ON %@ (db, tbl)", kVersionTbl]];
        [dbh close];
    }
}

- (void)getTblVersionForDB:(NSString *)db finishBlock:(void(^)(NSDictionary *))finishBlock
{
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    FMDatabase *dbh = [[FMDatabase alloc] initWithPath:_path];
    if ([dbh open]) {
        FMResultSet *res = [dbh executeQuery:[NSString stringWithFormat:@"SELECT tbl, version FROM %@ WHERE db=:db", kVersionTbl] withParameterDictionary:@{@"db":db}];
        while ([res next]) {
            NSDictionary *tblVersion = [res resultDictionary];
            ret[tblVersion[@"tbl"]] = @([tblVersion[@"version"] intValue]);
        }
        [dbh close];
    }
    finishBlock(ret);
}

- (void)getVersionForTbl:(NSString *)tbl inDB:(NSString *)db finishBlock:(void(^)(int version))finishBlock
{
    FMDatabase *dbh = [[FMDatabase alloc] initWithPath:_path];
    if ([dbh open]) {
        FMResultSet *res = [dbh executeQuery:[NSString stringWithFormat:@"SELECT version FROM %@ WHERE db=:db AND tbl=:tbl", kVersionTbl] withParameterDictionary:@{@"db":db, @"tbl":tbl}];
        if ([res next]) {
            finishBlock([[res resultDictionary][@"version"] intValue]);
        } else {
            finishBlock(0);
        }
        [dbh close];
    }
}

- (void)updateVersion:(int)version forTbl:(NSString *)tbl inDB:(NSString *)db
{
    FMDatabase *dbh = [[FMDatabase alloc] initWithPath:_path];
    if ([dbh open]) {
        [dbh executeUpdate:[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (db, tbl, version) VALUES (:db, :tbl, :version)", kVersionTbl] withParameterDictionary:@{@"db":db, @"tbl":tbl, @"version":@(version)}];
        [dbh close];
    }
}


@end
