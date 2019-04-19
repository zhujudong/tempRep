//
//  ProductSimpleCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/14/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductSimpleCell.h"

static CGFloat const TOP_BOTTOM_MARGIN = 12.0;

@implementation ProductSimpleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        //self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_keyLabel) {
            _keyLabel = [UILabel new];
            _keyLabel.numberOfLines = 0;
            _keyLabel.font = [UIFont systemFontOfSize:13];
            _keyLabel.textColor = [UIColor colorWithHexString:@"848689" alpha:1];

            [self.contentView addSubview:_keyLabel];
            [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.top.equalTo(self.contentView).offset(TOP_BOTTOM_MARGIN);
                make.bottom.equalTo(self.contentView).offset(-TOP_BOTTOM_MARGIN);
            }];
        }

        if (!_valueLabel) {
            _valueLabel = [UILabel new];
            _valueLabel.font = [UIFont systemFontOfSize:12];
            _valueLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
            _valueLabel.textAlignment = NSTextAlignmentLeft;

            [self.contentView addSubview:_valueLabel];
            [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_keyLabel.mas_trailing).offset(14);
                make.trailing.lessThanOrEqualTo(self.contentView);
                make.centerY.equalTo(_keyLabel);
            }];
        }
    }

    return self;
}

- (void)setTextForKey:(NSString *)key withValue:(NSString *)value {
    _valueLabel.text = value;
    _keyLabel.text = key;

    [_keyLabel sizeToFit];
    [_keyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(_keyLabel.bounds.size.width).priorityHigh();
    }];
}

@end
