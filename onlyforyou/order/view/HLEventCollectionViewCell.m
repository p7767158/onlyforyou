//
//  HLEventCollectionViewCell.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/11.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLEventCollectionViewCell.h"
#import "HLEvent.h"

@interface HLEventCollectionViewCell ()

@property (nonatomic, strong) HLEvent *event;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation HLEventCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        self.contentView.backgroundColor = RGBA(random() % 254 + 1, random() % 254 + 1, random() % 254 + 1, 1);
        
        RAC(self.titleLb, text) = RACObserve(self, event.desc);
    }
    return self;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [HLColor darkTextColor];
        _titleLb.font = [HLFont titleFont];
    }
    return _titleLb;
}

@end
