//
//  HLOrderDetailViewModel.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderDetailViewModel.h"
#import "HLOrder.h"
#import "HLAlertView.h"

@interface HLOrderDetailViewModel ()

@property (nonatomic, strong) HLOrder *order;

@end

@implementation HLOrderDetailViewModel

- (instancetype)initWithModel:(HLOrder *)order
{
    if (self = [super init]) {
        _order = order;
    }
    return self;
}

- (void)addOrderWithTitle:(NSString *)title detail:(NSString *)detail money:(NSString *)money finishBlock:(void (^)())finishBlock
{
    [self monitorWithTitle:title detail:detail money:money];
    [self.order create:^(BOOL successs) {
        if (successs) {
            if (finishBlock) {
                finishBlock();
            }
        }
    }];
}

- (void)modifyOrderWithTitle:(NSString *)title detail:(NSString *)detail money:(NSString *)money finishBlock:(void (^)())finishBlock
{
    [self monitorWithTitle:title detail:detail money:money];
    [self.order update:^(BOOL successs) {
        if (successs) {
            finishBlock();
        }
    }];
}

- (void)monitorWithTitle:(NSString *)title detail:(NSString *)detail money:(NSString *)money
{
    NSString *alertStr = @"";
    if (title.length == 0) {
        alertStr = @"不是，啥也没干记啥账？";
    } else if ([money doubleValue] <= 0) {
        alertStr = [NSString stringWithFormat:@"咋的，%@不用花钱啊?", title];
    }
    if (alertStr.length > 0) {
        return [HLAlertView showAlertWithMessage:alertStr];
    }
    
    if (!_order) {
        _order = [[HLOrder alloc] init];
    }
    _order.title = title;
    _order.detail = detail;
    _order.money = money.doubleValue;
}

@end
