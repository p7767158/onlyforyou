//
//  HLEventDB.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLBaseDB.h"

static NSString * const kEventDB = @"event.db";
static NSString * const kEventTbl = @"hl_event";

@class HLEvent;
@interface HLEventDB : HLBaseDB

+ (HLEventDB *)sharedHLEventDB;
- (void)initStore:(NSString *)baseUrl;

- (NSArray *)getEvents;
- (NSArray *)getHideEvents;

- (void)updateHideOfEvent:(HLEvent *)event;
- (void)updateRankOfEvent:(HLEvent *)event;

@end
