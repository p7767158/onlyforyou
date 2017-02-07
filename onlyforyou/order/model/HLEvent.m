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

+ (NSArray *)hideEvents
{
    return [[[[[HLEventDB sharedHLEventDB] getHideEvents] rac_sequence] map:^id(NSDictionary *dict) {
        return [HLEvent yy_modelWithDictionary:dict];
    }] array];
}

- (void)setHide:(BOOL)hide
{
    _hide = hide;
    
    [[HLEventDB sharedHLEventDB] updateHideOfEvent:self];
}

- (void)setRank:(NSInteger)rank
{
    _rank = rank;
    
    [[HLEventDB sharedHLEventDB] updateRankOfEvent:self];
}

@end
