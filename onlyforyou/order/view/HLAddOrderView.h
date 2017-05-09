//
//  HLAddOrderView.h
//  onlyforyou
//
//  Created by honghao5 on 17/2/8.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLEvent;

@interface HLAddOrderView : UIView

- (instancetype)initWithEvent:(HLEvent *)event;

+ (void)showWithEvent:(HLEvent *)event;

@end
