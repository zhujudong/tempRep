//
//  CheckoutPaymentMethodCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutPaymentMethodCell.h"

@interface CheckoutPaymentMethodCell()
@property (strong, nonatomic) UIImageView *checkImageView, *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation CheckoutPaymentMethodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_checkImageView) {
            _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked"] highlightedImage:[UIImage imageNamed:@"checked"]];

            [self.contentView addSubview:_checkImageView];
            [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20)).priorityHigh();
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];

            [self.contentView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_checkImageView.mas_trailing).offset(10);
                make.size.mas_equalTo(CGSizeMake(30, 30)).priorityHigh();
                make.top.equalTo(self.contentView).offset(14);
                make.bottom.equalTo(self.contentView).offset(-14);
            }];
        }

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            _titleLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_iconImageView.mas_trailing).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setPaymentMethod:(CheckoutPaymentMethodModel *)paymentMethod {
    _paymentMethod = paymentMethod;

    if (paymentMethod.icon.length) {
        [_iconImageView lazyLoad:_paymentMethod.icon];
    } else {
        _iconImageView.image = [UIImage imageNamed:@"placeholder"];
    }

    _titleLabel.text = _paymentMethod.title;
}

- (void)setCheckImageHighlighted:(BOOL)highlighted {
    [_checkImageView setHighlighted:highlighted];
}
@end
