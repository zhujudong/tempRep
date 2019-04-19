//
//  AccountAddressCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressCell.h"

@interface AccountAddressCell()
@property (strong, nonatomic) UILabel *nameLabel, *addressLabel;
@property (strong, nonatomic) UIButton *isDefaultButton, *editButton, *deleteButton;
@end

@implementation AccountAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_addressLabel) {
            _addressLabel = [UILabel new];
            _addressLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
            _addressLabel.font = [UIFont systemFontOfSize:13];
            _addressLabel.numberOfLines = 0;
            [self.contentView addSubview:_addressLabel];
            [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(10);
                make.leading.equalTo(self.contentView).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_isDefaultButton) {
            _isDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_isDefaultButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [_isDefaultButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateHighlighted];
            [_isDefaultButton setTitle:NSLocalizedString(@"button_cell_account_address_default", nil) forState:UIControlStateNormal];
            _isDefaultButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [_isDefaultButton setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
            [_isDefaultButton addTarget:self action:@selector(isDefaultButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_isDefaultButton];
            [_isDefaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_addressLabel.mas_bottom).offset(10);
                make.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_deleteButton) {
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [_deleteButton setTitle:NSLocalizedString(@"button_cell_account_address_delete", nil) forState:UIControlStateNormal];
            [_deleteButton setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
            _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_deleteButton];
            [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.and.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_editButton) {
            _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_editButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
            [_editButton setTitle:NSLocalizedString(@"button_cell_account_address_edit", nil) forState:UIControlStateNormal];
            [_editButton setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
            _editButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [_editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_editButton];
            [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_deleteButton);
                make.trailing.equalTo(_deleteButton.mas_leading).offset(-15);
            }];
        }
    }

    return self;
}

- (void)setAddress:(AccountAddressItemModel *)address {
    _address = address;
    _nameLabel.text = [_address fullnameWithTelephone];
    _addressLabel.text = [_address formattedAddress];
    _isDefaultButton.highlighted = _address.isDefault;
    _isDefaultButton.enabled = !_address.isDefault;
}

- (void)isDefaultButtonClicked {
    if (_address.isDefault) {
        return;
    }

    if (_isDefaultButtonClickedBlock) {
        _isDefaultButtonClickedBlock(_address.addressId);
    }
}

- (void)editButtonClicked {
    if (_editButtonClickedBlock) {
        _editButtonClickedBlock(_address);
    }
}

- (void)deleteButtonClicked {
    if (_deleteButtonClickedBlock) {
        _deleteButtonClickedBlock(_address);
    }
}

@end
