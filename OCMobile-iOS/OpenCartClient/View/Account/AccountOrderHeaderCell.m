//
//  AccountOrderHeaderCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderHeaderCell.h"

@implementation AccountOrderHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_order"]];
            [self.contentView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            _titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
            _titleLabel.text = NSLocalizedString(@"label_cell_account_home_order_header_title", nil);
            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.leading.equalTo(_iconImageView.mas_trailing).offset(10);
            }];
        }
        
        if (!_subTitleLabel) {
            _subTitleLabel = [UILabel new];
            _subTitleLabel.text = NSLocalizedString(@"label_cell_account_home_order_header_subtitle", nil);
            _subTitleLabel.textColor = [UIColor colorWithHexString:@"BDBDBF" alpha:1];
            _subTitleLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_subTitleLabel];
            [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.contentView);
                make.trailing.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

@end
