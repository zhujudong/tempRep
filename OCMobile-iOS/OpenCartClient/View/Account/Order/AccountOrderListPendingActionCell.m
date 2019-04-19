//
//  AccountOrderListPendingActionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListPendingActionCell.h"

static CGFloat const GUTTER=  10.0;

@interface AccountOrderListPendingActionCell()
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *cancelButton, *payButton;
@end

@implementation AccountOrderListPendingActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            _totalLabel.font = [UIFont systemFontOfSize:12];
            _totalLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            [self.contentView addSubview:_totalLabel];
            [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(GUTTER);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_payButton) {
            _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_payButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_pending_pay", nil) forState:UIControlStateNormal];
            [_payButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _payButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _payButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _payButton.layer.borderWidth = 0.5f;
            _payButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;

            [_payButton addTarget:self action:@selector(payButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_payButton];
            [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(28).priorityHigh();
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.trailing.and.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_cancelButton) {
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_pending_cancel", nil) forState:UIControlStateNormal];
            [_cancelButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _cancelButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _cancelButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _cancelButton.layer.borderWidth = 0.5f;
            _cancelButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;

            [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_cancelButton];
            [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(_payButton);
                make.trailing.equalTo(_payButton.mas_leading).offset(-GUTTER);
                make.centerY.equalTo(_payButton);
            }];
        }
    }

    return self;
}

- (void)setOrder:(AccountOrderListOrderItemModel *)order {
    _order = order;

    _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"order_qty_total", nil), _order.products.count, _order.totalFormat];
}

- (void)payButtonClicked {
    if (_order && _payButtonClickedBlock) {
        _payButtonClickedBlock(_order.orderId);
    }
}

- (void)cancelButtonClicked {
    if (_order && _cancelButtonClickedBlock) {
        _cancelButtonClickedBlock(_order.orderId);
    }
}
@end
