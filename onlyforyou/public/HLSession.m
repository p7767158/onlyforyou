//
//  HLSession.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLSession.h"
#import "HLTableVersionDB.h"
#import "HLOrderDB.h"

static NSString * const kUserDB = @"kUserDB";
static int const kDefaultUid = 0;

@interface HLSession ()

@property (nonatomic, copy) NSString *commenPath;
@property (nonatomic, copy) NSString *userPath;
@property (nonatomic, copy) NSDictionary *storePath;

@end

@implementation HLSession

SYNTHESIZE_SINGLETON_FOR_CLASS(HLSession);

- (void)restore
{
    [self _initStore];
}

- (void)_initStore
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _commenPath = paths[0];
    _userPath = [NSString stringWithFormat:@"%@/%d", _commenPath, kDefaultUid];
    if (![fileMgr fileExistsAtPath:_userPath]) {
        NSError *e;
        if (![fileMgr createDirectoryAtPath:_userPath withIntermediateDirectories:YES attributes:nil error:&e]) {
            NSLog(@"磁盘空间不足");
        }
    }
    _storePath = @{kUserDB:[NSString stringWithFormat:@"%@/%@/", _userPath, kUserDB]};
    
    [_storePath enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull path, BOOL * _Nonnull stop) {
        if (![fileMgr fileExistsAtPath:path]) {
            NSError *e;
            if (![fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&e]) {
                NSLog(@"磁盘空间不足");
                *stop = YES;
            }
        }
    }];
    
    [self _initDB];
}

- (void)_initDB
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *userDBPath = [NSString stringWithFormat:@"%@/me.db", _storePath[kUserDB]];
    if (![fileMgr fileExistsAtPath:userDBPath]) {
        [fileMgr createFileAtPath:userDBPath contents:nil attributes:nil];
    }
    [[HLTableVersionDB sharedHLTableVersionDB] initStore:_storePath[kUserDB]];
    [[HLOrderDB sharedHLOrderDB] initStore:_storePath[kUserDB]];
}

@end





























