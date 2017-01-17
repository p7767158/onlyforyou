//
//  HLOrderListViewModel.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderListViewModel.h"
#import "HLOrder.h"

@interface HLOrderListViewModel ()

@end

@implementation HLOrderListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self reload];
    }
    return self;
}

- (void)reload
{
    RAC(self, orderArray) = [[[HLOrder fetchOrderList] logError] catchTo:[RACSignal empty]];
    RAC(self, sumStr) = [[HLOrder fetchOrderSum] map:^id(id value) {
        return [NSString stringWithFormat:@"总计: %.2f", [value doubleValue]];
    }];
}

@end
