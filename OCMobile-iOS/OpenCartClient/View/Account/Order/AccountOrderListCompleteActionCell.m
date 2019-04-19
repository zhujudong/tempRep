//
//  AccountOrderListCompleteActionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/26/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListCompleteActionCell.h"

static CGFloat const GUTTER = 10.0;

@interface AccountOrderListCompleteActionCell()
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UIButton *expressButton, *viewButton;
@end

@implementation AccountOrderListCompleteActionCell

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

        if (!_viewButton) {
            _viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_viewButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_complete_view_order", nil) forState:UIControlStateNormal];
            [_viewButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _viewButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _viewButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _viewButton.layer.borderWidth = 0.5f;
            _viewButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            [_viewButton addTarget:self action:@selector(viewButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_viewButton];
            [_viewButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(28).priorityHigh();
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.trailing.and.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_expressButton) {
            _expressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_expressButton setTitle:NSLocalizedString(@"button_cell_account_order_list_action_complete_express", nil) forState:UIControlStateNormal];
            [_expressButton setTitleColor:CONFIG_PRIMARY_COLOR forState:UIControlStateNormal];
            _expressButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _expressButton.layer.borderColor = CONFIG_PRIMARY_COLOR.CGColor;
            _expressButton.layer.borderWidth = 0.5f;
            _expressButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            [_expressButton addTarget:self action:@selector(expressButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_expressButton];
            [_expressButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(_viewButton);
                make.trailing.equalTo(_viewButton.mas_leading).offset(-GUTTER);
                make.centerY.equalTo(_viewButton);
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

- (void)viewButtonClicked {
    if (_order && _viewButtonClickedBlock) {
        _viewButtonClickedBlock(_order.orderId);
    }
}

- (void)expressButtonClicked {
    if (_order && _expressButtonClickedBlock) {
        _expressButtonClickedBlock(_order.orderId);
    }
}
@end
