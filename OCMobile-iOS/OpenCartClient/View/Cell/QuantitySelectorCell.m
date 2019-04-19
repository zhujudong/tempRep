//
//  QuantitySelectorCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 23/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "QuantitySelectorCell.h"

@implementation QuantitySelectorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_label) {
            _label = [UILabel new];
            _label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_quantityControl) {
            _quantityControl = [[UIQuantityControl alloc] initWithFrame:CGRectZero];
            _quantityControl.delegate = self;

            [self.contentView addSubview:_quantityControl];
            [_quantityControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(30);
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPlaceholder:(NSString *)text value:(NSInteger)value {
    self.label.text = text;
    [_quantityControl setQuantity:value];
}

- (void)quantityChangedTo:(NSInteger)number tag:(NSUInteger)tag {
    if (self.quantityValueChangedBlock) {
        self.quantityValueChangedBlock(number);
    }
}


@end
