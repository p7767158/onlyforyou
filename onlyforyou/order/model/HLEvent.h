//
//  HLEvent.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLEvent : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, assign, getter=isHide) BOOL hide;

+ (NSArray *)events;

@end
