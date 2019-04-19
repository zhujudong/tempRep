//
//  AccountOrderListShippedActionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/26/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListShippedActionCell.h"

static CGFloat const GUTTER=  10.0;

@interface AccountOrderListShippedActionCell()
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *expressButton, *completeButton;
@end

@implementation AccountOrderListShippedActionCell

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

        if (!_completeButton) {
            _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_completeButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_shipped_complete", nil) forState:UIControlStateNormal];
            [_completeButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _completeButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _completeButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _completeButton.layer.borderWidth = 0.5f;
            _completeButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            [_completeButton addTarget:self action:@selector(completeButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_completeButton];
            [_completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(28).priorityHigh();
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.trailing.and.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_expressButton) {
            _expressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_expressButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_shipped_express", nil) forState:UIControlStateNormal];
            [_expressButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _expressButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _expressButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _expressButton.layer.borderWidth = 0.5f;
            _expressButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            [_expressButton addTarget:self action:@selector(expressButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_expressButton];
            [_expressButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(_completeButton);
                make.trailing.equalTo(_completeButton.mas_leading).offset(-GUTTER);
                make.centerY.equalTo(_completeButton);
            }];
        }
    }

    return self;
}

- (void)setOrder:(AccountOrderListOrderItemModel *)order {
    _order = order;

    _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"order_qty_total", nil), _order.products.count, _order.totalFormat];

    [_expressButton setHidden:!_order.hasTracks];
}

- (void)completeButtonClicked {
    if (_order && _completeButtonClickedBlock) {
        _completeButtonClickedBlock(_order.orderId);
    }
}

- (void)expressButtonClicked {
    if (_order && _expressButtonClickedBlock) {
        _expressButtonClickedBlock(_order.orderId);
    }
}

@end
