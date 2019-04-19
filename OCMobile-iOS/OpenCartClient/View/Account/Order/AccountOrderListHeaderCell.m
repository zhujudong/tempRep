//
//  AccountOrderListHeaderCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/16/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListHeaderCell.h"

static CGFloat const GUTTER = 10.0;

@interface AccountOrderListHeaderCell()
@property (strong, nonatomic) UILabel *orderIdLabel, *orderDateLabel, *orderStatusLabel;
@end

@implementation AccountOrderListHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_orderIdLabel) {
            _orderIdLabel = [UILabel new];
            _orderIdLabel.font = [UIFont systemFontOfSize:13];
            _orderIdLabel.textColor = [UIColor colorWithHexString:@"363636" alpha:1];

            [self.contentView addSubview:_orderIdLabel];
            [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_orderDateLabel) {
            _orderDateLabel = [UILabel new];
            _orderDateLabel.font = [UIFont systemFontOfSize:11];
            _orderDateLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];

            [self.contentView addSubview:_orderDateLabel];
            [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_orderIdLabel.mas_trailing).offset(GUTTER);
                make.centerY.equalTo(_orderIdLabel);
            }];
        }

        if (!_orderStatusLabel) {
            _orderStatusLabel = [UILabel new];
            _orderStatusLabel.font = [UIFont systemFontOfSize:12];
            _orderStatusLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_orderStatusLabel];
            [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
                make.centerY.equalTo(_orderIdLabel);
            }];
        }
    }

    return self;
}

- (void)setOrder:(AccountOrderListOrderItemModel *)order {
    _order = order;

    _orderIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"order_number", nil), _order.orderId];
    _orderDateLabel.text = [NSString stringWithFormat:@"%@", _order.dateAdded];
    _orderStatusLabel.text = _order.orderStatusName;

}
@end
