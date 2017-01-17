//
//  HLSession.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/5.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSession : NSObject

@property (nonatomic, strong) NSArray *events;

+ (HLSession *)sharedHLSession;
- (void)restore;

- (void)setUserDefault:(id)value forKey:(NSString *)key;
- (id)userDefaultForKey:(NSString *)key;

@end
