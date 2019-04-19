//
//  AccountCouponCellStyle2.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/29/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountCouponCellStyle2.h"

@interface AccountCouponCellStyle2()
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UILabel *totalLabel, *nameLabel, *conditionLabel, *dateLabel;
@property (strong, nonatomic) UIView *dashLine;
@end

@implementation AccountCouponCellStyle2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_backgroundImageView) {
            _backgroundImageView = [UIImageView new];

            UIImage *backgroundImage = [[UIImage imageNamed:@"coupon_item_bg_style2"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            _backgroundImageView.image = backgroundImage;

            self.backgroundView = _backgroundImageView;
            [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }

        if (!_totalLabel) {
            _totalLabel = [UILabel new];
            _totalLabel.font = [UIFont boldSystemFontOfSize:36];
            _totalLabel.textColor = [UIColor whiteColor];
            _totalLabel.adjustsFontSizeToFitWidth = YES;

            [self.contentView addSubview:_totalLabel];
            [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.width.mas_equalTo(72);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_dashLine) {
            _dashLine = [UIView new];

            _dashLine.backgroundColor = [UIColor whiteColor];

            [self addSubview:_dashLine];
            [_dashLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_totalLabel.mas_trailing).offset(20);
                make.top.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
                make.width.mas_equalTo(0.5);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:20];
            _nameLabel.textColor = [UIColor whiteColor];
            _totalLabel.adjustsFontSizeToFitWidth = YES;

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(self.contentView).offset(120);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_conditionLabel) {
            _conditionLabel = [UILabel new];
            _conditionLabel.font = [UIFont systemFontOfSize:18];
            _conditionLabel.textColor = CONFIG_PRIMARY_COLOR;
            _conditionLabel.backgroundColor = [UIColor whiteColor];

            [self.contentView addSubview:_conditionLabel];
            [_conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor whiteColor];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_nameLabel);
                make.bottom.equalTo(self.contentView).offset(-10);
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
