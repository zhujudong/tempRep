//
//  CheckoutShippingMethodCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingMethodCell.h"

@interface CheckoutShippingMethodCell()
@property (strong, nonatomic) UIImageView *checkImageView;
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@end

@implementation CheckoutShippingMethodCell

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
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            _titleLabel.textColor = [UIColor colorWithHexString:@"000000" alpha:1];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(16);
                make.bottom.equalTo(self.contentView).offset(-16);
                make.leading.equalTo(_checkImageView.mas_trailing).offset(10);
            }];
        }

        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.font = [UIFont systemFontOfSize:13];
            _valueLabel.textColor = [UIColor colorWithHexString:@"666666" alpha:1];

            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_titleLabel);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setShippingMethod:(CheckoutShippingMethodModel *)shippingMethod {
    _shippingMethod = shippingMethod;

    _titleLabel.text = _shippingMethod.title;
    _valueLabel.text = _shippingMethod.costFormat;
}

- (void)setCheckImageHighlighted:(BOOL)highlighted {
    [_checkImageView setHighlighted:highlighted];
}
@end
