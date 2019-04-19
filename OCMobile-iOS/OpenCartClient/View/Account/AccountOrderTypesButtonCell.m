//
//  AccountOrderTypesButtonCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderTypesButtonCell.h"

static CGFloat const HEIGHT = 60.0;

@implementation AccountOrderTypesButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_unpaidControl) {
            _unpaidControl = [UIOrderTypeButton new];
            [_unpaidControl setAssetKey:@"unpaid"];
            [self.contentView addSubview:_unpaidControl];
        }

        if (!_unshippedControl) {
            _unshippedControl = [UIOrderTypeButton new];
            [_unshippedControl setAssetKey:@"unshipped"];
            [self.contentView addSubview:_unshippedControl];
        }

        if (!_shippedControl) {
            _shippedControl = [UIOrderTypeButton new];
            [_shippedControl setAssetKey:@"shipped"];
            [self.contentView addSubview:_shippedControl];
        }

        if (!_reviewControl) {
            _reviewControl = [UIOrderTypeButton new];
            [_reviewControl setAssetKey:@"unreviewed"];
            [self.contentView addSubview:_reviewControl];
        }

        if (!_returnControl) {
            _returnControl = [UIOrderTypeButton new];
            [_returnControl setAssetKey:@"return"];
            [self.contentView addSubview:_returnControl];
        }

        [_unpaidControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@[_unshippedControl, _shippedControl, _reviewControl, _returnControl]);
            make.height.mas_equalTo(HEIGHT).priorityHigh();
        }];

        [_unshippedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_unpaidControl.mas_trailing);
            make.top.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@[_unpaidControl, _shippedControl, _reviewControl, _returnControl]);
            make.height.equalTo(_unpaidControl.mas_height);
        }];

        [_shippedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_unshippedControl.mas_trailing);
            make.top.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@[_unpaidControl, _unshippedControl, _reviewControl, _returnControl]);
            make.height.equalTo(_unpaidControl.mas_height);
        }];

        [_reviewControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_shippedControl.mas_trailing);
            make.top.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@[_unpaidControl, _unshippedControl, _shippedControl, _returnControl]);
            make.height.equalTo(_unpaidControl.mas_height);
        }];

        [_returnControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_reviewControl.mas_trailing);
            make.top.trailing.and.bottom.equalTo(self.contentView);
            make.width.equalTo(@[_unpaidControl, _unshippedControl, _shippedControl, _reviewControl]);
            make.height.equalTo(_unpaidControl.mas_height);
        }];
    }

    return self;
}

@end
