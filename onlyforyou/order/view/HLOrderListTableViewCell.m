//
//  HLOrderListTableViewCell.m
//  onlyforyou
//
//  Created by honghao5 on 17/1/6.
//  Copyright © 2017年 honghao5. All rights reserved.
//

#import "HLOrderListTableViewCell.h"
#import "HLOrder.h"

@interface HLOrderListTableViewCell ()

@property (nonatomic, strong) HLOrder *order;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *moneyLb;

@end

@implementation HLOrderListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.moneyLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
        [self.moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
        }];
        
        RAC(self.titleLb, text) = RACObserve(self, order.title);
        RAC(self.moneyLb, text) = [RACObserve(self, order.money) map:^id(NSNumber *money) {
            return [NSString stringWithFormat:@"￥%.2f", money.doubleValue];
        }];
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

- (UILabel *)moneyLb
{
    if (!_moneyLb) {
        _moneyLb = [[UILabel alloc] init];
        _moneyLb.font = [HLFont titleFont];
        _moneyLb.textColor = [HLColor redColor];
    }
    return _moneyLb;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
