//
//  HLEvent.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEvent.h"
#import "HLEventDB.h"

@implementation HLEvent

+ (NSArray *)events
{
    return [[[[[HLEventDB sharedHLEventDB] getEvents] rac_sequence] map:^id(NSDictionary *dict) {
        return [HLEvent yy_modelWithDictionary:dict];
    }] array];
}

@end
