//
//  HLOrderListTableViewCell.h
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kOrderListCell = @"kOrderListCell";

@class HLOrder;
@interface HLOrderListTableViewCell : UITableViewCell

- (void)setOrder:(HLOrder *)order;

@end
