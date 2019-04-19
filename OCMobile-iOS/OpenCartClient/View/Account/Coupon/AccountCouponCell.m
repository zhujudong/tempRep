//
//  AccountCouponCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountCouponCell.h"

@interface AccountCouponCell()
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *couponLabel, *totalLabel, *nameLabel, *conditionLabel, *dateLabel;
@property (strong, nonatomic) UIView *dashLine;
@end

@implementation AccountCouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_backgroundImageView) {
            _backgroundImageView = [UIImageView new];

            UIImage *backgroundImage = [[UIImage imageNamed:@"coupon_item_bg"] stretchableImageWithLeftCapWidth:40 topCapHeight:65];
            _backgroundImageView.image = backgroundImage;

            self.backgroundView = _backgroundImageView;
            [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }

        if (!_couponLabel) {
            _couponLabel = [UILabel new];
            _couponLabel.font = [UIFont boldSystemFontOfSize:15];
            _couponLabel.textColor = [UIColor whiteColor];
            _couponLabel.textAlignment = NSTextAlignmentCenter;
            _couponLabel.text = @"优惠券";
            _couponLabel.numberOfLines = 3;

            [self.contentView addSubview:_couponLabel];
            [_couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(8);
                make.width.mas_equalTo(24);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            _totalLabel.font = [UIFont boldSystemFontOfSize:32];
            _totalLabel.textColor = CONFIG_PRIMARY_COLOR;
            _totalLabel.adjustsFontSizeToFitWidth = YES;

            [self.contentView addSubview:_totalLabel];
            [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(20);
                make.leading.equalTo(self.contentView).offset(50);
                make.width.mas_equalTo(80);
            }];
        }

        if (!_dashLine) {
            _dashLine = [UIView new];

            _dashLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dash_line"]];

            [self addSubview:_dashLine];
            [_dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_totalLabel);
                make.trailing.equalTo(self.contentView).offset(-30);
                make.top.equalTo(_totalLabel.mas_bottom).offset(10);
                make.height.mas_equalTo(0.5);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:13];
            _dateLabel.textColor = [UIColor colorWithHexString:@"C5C5C5" alpha:1];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_totalLabel);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _nameLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(self.contentView).offset(160);
            }];
        }

        if (!_conditionLabel) {
            _conditionLabel = [UILabel new];
            _conditionLabel.font = [UIFont systemFontOfSize:11];
            _conditionLabel.textColor = [UIColor colorWithHexString:@"ADADAD" alpha:1];

            [self.contentView addSubview:_conditionLabel];
            [_conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(10);
            }];
        }
    }

    return self;
}

- (void)setCoupon:(AccountCouponModel *)coupon {
    _coupon = coupon;

    if ([_coupon.type isEqualToString:@"F"]) { //Fix rate
        _totalLabel.text = [NSString stringWithFormat:@"￥%.02f",_coupon.discount];
    } else { //Percent
        if ([[System sharedInstance] isSimplifiedChineseLanguage]) {
            _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_discount_rate", nil), (100 - _coupon.discount) / 10];
        } else {
            _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_discount_rate", nil), _coupon.discount];
        }
    }

    _nameLabel.text = _coupon.name;

    _conditionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_coupon_condition_no_total", nil), (int)_coupon.total];

    _dateLabel.text = [NSString stringWithFormat:@"%@ - %@", _coupon.dateStart, _coupon.dateEnd];
}
@end
