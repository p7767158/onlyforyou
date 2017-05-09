//
//  HLAddOrderView.m
//  onlyforyou
//
//  Created by honghao5 on 17/2/8.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLAddOrderView.h"
#import "HLEvent.h"

@interface HLAddOrderView ()

@property (nonatomic, strong) HLEvent *event;
@property (nonatomic, strong) UITextField *moneyTf;
@property (nonatomic, strong) UILabel *moneyLb;
@property (nonatomic, strong) UITextField *descTf;
@property (nonatomic, strong) UILabel *descLb;
@property (nonatomic, strong) UIImageView *icnImage;
@property (nonatomic, strong) UILabel *eventLb;

@end

@implementation HLAddOrderView

- (instancetype)initWithEvent:(HLEvent *)event
{
    if (self = [super init]) {
        _event = event;
    }
    return self;
}

- (UITextField *)moneyTf
{
    if (!_moneyTf) {
        _moneyTf = [[UITextField alloc] init];
    }
    return _moneyTf;
}

- (UILabel *)moneyLb
{
    if (!_moneyLb) {
        _moneyLb = [[UILabel alloc] init];
        _moneyLb.text = @"￥";
    }
    return _moneyLb;
}

- (UITextField *)descTf
{
    if (!_descTf) {
        _descTf = [[UITextField alloc] init];
    }
    return _descTf;
}

- (UILabel *)descLb
{
    if (!_descLb) {
        _descLb = [[UILabel alloc] init];
    }
    return _descLb;
}

- (UIImageView *)icnImage
{
    if (!_icnImage) {
        _icnImage = [[UIImageView alloc] init];
    }
    return _icnImage;
}

- (UILabel *)eventLb
{
    if (!_eventLb) {
        _eventLb = [[UILabel alloc] init];
    }
    return _eventLb;
}

+ (void)showWithEvent:(HLEvent *)event
{
    
}

@end
