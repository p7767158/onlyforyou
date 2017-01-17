//
//  HLEventCollectionViewCell.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kEventCollectionCell = @"kEventCollectionCell";

@class HLEvent;
@interface HLEventCollectionViewCell : UICollectionViewCell

- (void)setEvent:(HLEvent *)event;

@end
