//
//  HLOrder.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLOrder : NSObject

@property (nonatomic, assign) long long oid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) long updateTime;
@property (nonatomic, assign) double money;

- (void)create:(HLSuccessBlock)finishBlock;
- (void)update:(HLSuccessBlock)finishBlock;
- (void)delete:(HLSuccessBlock)finishBlock;

+ (RACSignal *)fetchOrderList;
+ (RACSignal *)fetchOrderSum;

@end
