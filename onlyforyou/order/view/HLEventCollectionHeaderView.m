//
//  HLEventCollectionHeaderView.m
//  onlyforyou
//
//  Created by honghao5 on 17/2/7.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEventCollectionHeaderView.h"

@interface HLEventCollectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, copy) NSString *title;

@end

@implementation HLEventCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self);
        }];
        
        RAC(self.titleLb, text) = RACObserve(self, title);
    }
    return self;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [HLFont titleFont];
        _titleLb.textColor = [HLColor darkTextColor];
    }
    return _titleLb;
}

@end
