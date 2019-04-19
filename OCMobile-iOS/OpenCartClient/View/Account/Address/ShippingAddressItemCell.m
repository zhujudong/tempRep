//
//  ShippingAddressItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ShippingAddressItemCell.h"

@interface ShippingAddressItemCell()
@property (strong, nonatomic) UILabel *nameLabel, *addressLabel;
@property (strong, nonatomic) UIImageView *checkImageView;
@property (strong, nonatomic) UIButton *editButton;
@end

@implementation ShippingAddressItemCell

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

        if (!_editButton) {
            _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_editButton setImage:[UIImage imageNamed:@"edit_address"] forState:UIControlStateNormal];
            [_editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_editButton];
            [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 40));
                make.centerY.equalTo(self.contentView);
                make.trailing.equalTo(self.contentView).offset(-20);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:15];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(_checkImageView.mas_trailing).offset(10);
                make.trailing.equalTo(_editButton.mas_leading).offset(-10);
            }];
        }

        if (!_addressLabel) {
            _addressLabel = [UILabel new];
            _addressLabel.numberOfLines = 0;
            _addressLabel.font = [UIFont systemFontOfSize:13];
            _addressLabel.textColor = [UIColor colorWithHexString:@"666666" alpha:1];

            [self.contentView addSubview:_addressLabel];
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.and.trailing.equalTo(_nameLabel);
                make.top.equalTo(_nameLabel.mas_bottom).offset(5);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setAddress:(AccountAddressItemModel *)address {
    _address = address;
    _nameLabel.text = [_address fullnameWithTelephone];

    if (_address.isDefault) {
        _addressLabel.text = [NSString stringWithFormat:@"[%@] %@", NSLocalizedString(@"text_default", nil), [_address formattedAddress]];
    } else {
        _addressLabel.text = [_address formattedAddress];
    }
}

- (void)setCheckImageHighlighted:(BOOL)highlighted {
    [_checkImageView setHighlighted:highlighted];
}

- (void)editButtonClicked {
    if (self.editButtonClickedBlock) {
        self.editButtonClickedBlock(_address);
    }
}

@end
