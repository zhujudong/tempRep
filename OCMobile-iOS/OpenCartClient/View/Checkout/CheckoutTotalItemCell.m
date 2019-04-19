//
//  CheckoutTotalItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutTotalItemCell.h"

@interface CheckoutTotalItemCell()
@property (strong, nonatomic) UILabel *titleLabel, *valueLabel;
@end

@implementation CheckoutTotalItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:12];
            _titleLabel.textColor = [UIColor colorWithHexString:@"4C4C4C" alpha:1];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(12);
                make.bottom.equalTo(self.contentView).offset(-12);
                make.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.font = [UIFont systemFontOfSize:14];
            _valueLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_titleLabel);
                make.trailing.equalTo(self.contentView).offset(-20);
            }];
        }
    }

    return self;
}

- (void)setTotal:(CheckoutTotalItemModel *)total {
    _titleLabel.text = total.title;
    _valueLabel.text = total.valueFormat;
}

- (void)setTitle:(NSString *)title withValue:(NSString *)value {
    _titleLabel.text = title;
    _valueLabel.text = value;
}
@end
