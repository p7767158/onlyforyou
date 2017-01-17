//
//  HLOrderListViewModel.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLOrderListViewModel : NSObject

@property (nonatomic, strong) NSArray *orderArray;
@property (nonatomic, copy) NSString *sumStr;

- (void)reload;

@end
