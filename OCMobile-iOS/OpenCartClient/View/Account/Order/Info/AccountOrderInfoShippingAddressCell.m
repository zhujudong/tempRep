//
//  AccountOrderInfoShippingAddressCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoShippingAddressCell.h"

@interface AccountOrderInfoShippingAddressCell ()
@property (strong, nonatomic) UIImageView *iconImageView, *bottomSepImageView;
@property (strong, nonatomic) UILabel *nameLabel, *addressLabel;
@end

@implementation AccountOrderInfoShippingAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
            _iconImageView.clipsToBounds = YES;

            [self.contentView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:14];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(40);
                make.top.equalTo(self.contentView).offset(15);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_addressLabel) {
            _addressLabel = [UILabel new];
            _addressLabel.numberOfLines = 0;
            _addressLabel.font = [UIFont systemFontOfSize:12];
            _addressLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_addressLabel];
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
                make.trailing.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-15);
                make.leading.equalTo(_nameLabel);
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

- (void)setOrder:(AccountOrderInfoModel *)order {
    _order = order;
    _nameLabel.text = [_order fullnameWithTelephone];
    _addressLabel.text = [_order formattedAddress];
}

@end
