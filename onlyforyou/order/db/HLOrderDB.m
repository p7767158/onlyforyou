//
//  HLOrderDB.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderDB.h"
#import "HLTableVersionDB.h"

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
                [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (oid integer primary key, title varchar, detail varchar, money integer default 0, create_time mediumint, update_time mediumint)", kOrderTbl]];
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

@end
