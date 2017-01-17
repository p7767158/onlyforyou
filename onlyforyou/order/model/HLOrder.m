//
//  HLOrder.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrder.h"
#import "HLOrderDB.h"

@implementation HLOrder

- (void)create:(HLSuccessBlock)finishBlock
{
    self.createTime = self.updateTime = [HLGlobal currentTimestamp];
    [[HLOrderDB sharedHLOrderDB] create:self finish:finishBlock];
}

- (void)update:(HLSuccessBlock)finishBlock
{
    self.updateTime = [HLGlobal currentTimestamp];
    [[HLOrderDB sharedHLOrderDB] update:self finish:finishBlock];
}

- (void)delete:(HLSuccessBlock)finishBlock
{
    [[HLOrderDB sharedHLOrderDB] deleteWithOid:self.oid finish:finishBlock];
}

+ (RACSignal *)fetchOrderList
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    [[HLOrderDB sharedHLOrderDB] getOrderList:^(NSArray *res) {
        [subject sendNext:[[[res rac_sequence] map:^id(NSDictionary *dict) {
            return [HLOrder yy_modelWithDictionary:dict];
        }] array]];
        [subject sendCompleted];
    }];
    return subject;
}

+ (RACSignal *)fetchOrderSum
{
    RACReplaySubject *subject = [RACReplaySubject subject];
    [[HLOrderDB sharedHLOrderDB] getOrderSum:^(NSArray *res) {
        NSDictionary *sumDict = [res firstObject];
        [subject sendNext:sumDict.allValues.firstObject];
        [subject sendCompleted];
    }];
    return subject;
}

@end
