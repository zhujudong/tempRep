//
//  CheckoutCouponItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutCouponItemCell.h"

@interface CheckoutCouponItemCell()
@property (strong, nonatomic) UIImageView *checkImageView;
@property (strong, nonatomic) UILabel *amountLabel, *conditionLabel, *dateLabel;
@end

@implementation CheckoutCouponItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_checkImageView) {
            _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked"] highlightedImage:[UIImage imageNamed:@"checked"]];

            [self.contentView addSubview:_checkImageView];
            [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_amountLabel) {
            _amountLabel = [UILabel new];
            _amountLabel.numberOfLines = 0;
            _amountLabel.font = [UIFont boldSystemFontOfSize:16];
            _amountLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_amountLabel];
            [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(_checkImageView.mas_trailing).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_conditionLabel) {
            _conditionLabel = [UILabel new];
            _conditionLabel.numberOfLines = 0;
            _conditionLabel.font = [UIFont systemFontOfSize:13];
            _conditionLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_conditionLabel];
            [_conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.trailing.equalTo(_amountLabel);
                make.top.equalTo(_amountLabel.mas_bottom).offset(8);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_amountLabel);
                make.top.equalTo(_conditionLabel.mas_bottom).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setCoupon:(CheckoutCouponModel *)coupon {
    NSString *amountText = nil;
    if ([coupon.type isEqualToString:@"F"]) { //Fix rate
        amountText = [NSString stringWithFormat:@"￥%.02f",coupon.discount];
    } else { // Percentage
        NSLocale *locale = [NSLocale currentLocale];
        if ([[locale localeIdentifier] isEqualToString:@"zh_Hans"] || [[locale localeIdentifier] isEqualToString:@"zh_CN"]) {
            amountText = [NSString stringWithFormat:NSLocalizedString(@"text_discount_rate", nil), (100 - coupon.discount) / 10];
        } else {
            amountText = [NSString stringWithFormat:NSLocalizedString(@"text_discount_rate", nil), coupon.discount];
        }
    }

    _amountLabel.text = amountText;
    _conditionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_coupon_condition", nil), coupon.name, (int)coupon.total];
    _dateLabel.text = [NSString stringWithFormat:@"%@ - %@", coupon.dateStart, coupon.dateEnd];
}

- (void)setImageHighlighted:(BOOL)highlighted {
    _checkImageView.highlighted = highlighted;
}

@end
