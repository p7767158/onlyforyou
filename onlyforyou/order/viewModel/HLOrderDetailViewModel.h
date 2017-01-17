//
//  HLOrderDetailViewModel.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLOrder;
@interface HLOrderDetailViewModel : NSObject

- (instancetype)initWithModel:(HLOrder *)order;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *money;

- (void)addOrderWithTitle:(NSString *)title detail:(NSString *)detail money:(NSString *)money finishBlock:(void(^)())finishBlock;
- (void)modifyOrderWithTitle:(NSString *)title detail:(NSString *)detail money:(NSString *)money finishBlock:(void(^)())finishBlock;

@end
