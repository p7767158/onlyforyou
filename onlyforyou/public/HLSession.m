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
#import "HLEventDB.h"
#import "HLEvent.h"

static NSString *const kUserDefaults = @"kUserDefaults";

static NSString *const kUserDB = @"kUserDB";
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
    [[HLEventDB sharedHLEventDB] initStore:_storePath[kUserDB]];
}

- (NSArray *)events
{
    if (!_events) {
        _events = [HLEvent events];
    }
    
    if (_events.count <= 0) {
        _events = @[@{@"rank":@0, @"desc":@"吃饭"}, @{@"rank":@1, @"desc":@"打车"}, @{@"rank":@2, @"desc":@"买菜"}, @{@"rank":@3, @"desc":@"超市"}, @{@"rank":@4, @"desc":@"公交"}, @{@"rank":@5, @"desc":@"淘宝"}];
    }
    
    _events = [[[_events rac_sequence] map:^id(NSDictionary *value) {
        return [HLEvent yy_modelWithDictionary:value];
    }] array];
    
    return _events;
}

- (void)setUserDefault:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *defaults = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults] mutableCopy];
    if (!defaults) {
        defaults = @{}.mutableCopy;
    }
    
    if (nil != value) {
        defaults[key] = value;
    } else {
        [defaults removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:kUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)userDefaultForKey:(NSString *)key
{
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults];
    return defaults[key];
}

@end





























