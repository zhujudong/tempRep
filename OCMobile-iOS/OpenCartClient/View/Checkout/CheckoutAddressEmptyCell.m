//
//  CheckoutAddressEmptyCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/1/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutAddressEmptyCell.h"

@implementation CheckoutAddressEmptyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkout_add_address"]];

            [self.contentView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.leading.equalTo(self.contentView).offset(15);
            }];
        }

        if (!_label) {
            _label = [UILabel new];
            _label.text = NSLocalizedString(@"label_cell_checkout_address_empty", nil);
            _label.font = [UIFont systemFontOfSize:14];
            _label.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(25);
                make.bottom.equalTo(self.contentView).offset(-25);
                make.leading.equalTo(_iconImageView.mas_trailing).offset(10);
            }];
        }

        if (!_bottomSepImageView) {
            _bottomSepImageView = [UIImageView new];
            _bottomSepImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"address_sep"]];
            [self.contentView addSubview:_bottomSepImageView];
            [_bottomSepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(2);
                make.leading.and.trailing.equalTo(self);
                make.bottom.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

@end
