//
//  HLEventDB.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEventDB.h"
#import "HLTableVersionDB.h"
#import "HLSession.h"
#import "HLEvent.h"

static int const kTblVersionEvent = 1;

@implementation HLEventDB

SYNTHESIZE_SINGLETON_FOR_CLASS(HLEventDB);

- (void)initStore:(NSString *)baseUrl
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", baseUrl, kEventDB];
    [self setDB:path];
    
    @weakify(self);
    [[HLTableVersionDB sharedHLTableVersionDB] getTblVersionForDB:kEventDB finishBlock:^(NSDictionary *versions) {
        FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
        if ([db open]) {
            if (!versions || !versions[kEventTbl] || (kTblVersionEvent > [versions[kEventTbl] integerValue])) {
                [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", kEventTbl]];
                [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (eid integer primary key autoincrement, desc varchar, rank integer default 0, hide integer default 0)", kEventTbl]];
                [[HLTableVersionDB sharedHLTableVersionDB] updateVersion:kTblVersionEvent forTbl:kEventTbl inDB:kEventDB];
            }
            [db close];
        }
        
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
        [queue inDatabase:^(FMDatabase *db) {
            for (HLEvent *event in [[HLSession sharedHLSession] events]) {
                [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@ (desc, rank) VALUES (:desc, :rank)", kEventTbl] withParameterDictionary:@{@"desc":event.desc, @"rank":@(event.rank)}];
            }
        }];
        [queue close];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            @strongify(self);
            [self run];
        });
    }];
}

- (NSArray *)getEvents
{
    return [self doSyncRead:[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY rank", kEventTbl] withParams:@{}];
}

@end
