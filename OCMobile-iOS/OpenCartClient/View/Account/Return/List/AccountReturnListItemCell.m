//
//  AccountReturnListItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnListItemCell.h"

@interface AccountReturnListItemCell()
@property (strong, nonatomic) UILabel *idLabel, *nameLabel, *statusLabel, *dateLabel, *detailLabel;;
@property (strong, nonatomic) UIView *sepLine;
@end

@implementation AccountReturnListItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_idLabel) {
            _idLabel = [UILabel new];
            _idLabel.font = [UIFont systemFontOfSize:12];
            _idLabel.textColor = [UIColor colorWithHexString:@"7A7A7A" alpha:1];
            [self.contentView addSubview:_idLabel];

            [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_sepLine) {
            _sepLine = [UIView new];
            _sepLine.backgroundColor = [UIColor colorWithHexString:@"d8d8d8" alpha:1];
            [self.contentView addSubview:_sepLine];

            [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(.5);
                make.leading.and.trailing.equalTo(self.contentView);
                make.top.equalTo(_idLabel.mas_bottom).offset(10);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_sepLine.mas_bottom).offset(20);
                make.leading.equalTo(_idLabel);
            }];
        }

        if (!_statusLabel) {
            _statusLabel = [UILabel new];
            _statusLabel.font = [UIFont systemFontOfSize:12];
            _statusLabel.textColor = [UIColor colorWithHexString:@"E4393C" alpha:1];
            [self.contentView addSubview:_statusLabel];
            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(10);
                make.leading.equalTo(_idLabel);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor colorWithHexString:@"7A7A7A" alpha:1];
            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_statusLabel.mas_bottom).offset(10);
                make.leading.equalTo(_idLabel);
            }];
        }

        if (!_detailLabel) {
            _detailLabel = [UILabel new];
            _detailLabel.font = [UIFont systemFontOfSize:12];
            _detailLabel.text = NSLocalizedString(@"label_cell_account_return_item_details", nil);
            _detailLabel.textAlignment = NSTextAlignmentCenter;
            _detailLabel.layer.borderColor = [UIColor colorWithHexString:@"979797" alpha:1.].CGColor;
            _detailLabel.layer.cornerRadius = 4.;
            _detailLabel.layer.borderWidth = .5;
            _detailLabel.clipsToBounds = YES;
            [self.contentView addSubview:_detailLabel];
            [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(33);
                make.width.mas_equalTo(90);
                make.top.equalTo(_dateLabel.mas_bottom).offset(10);
                make.trailing.and.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setReturnModel:(AccountReturnListItemModel *)returnModel {
    _returnModel = returnModel;

    _idLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_return_id", nil), _returnModel.returnId];
    _nameLabel.text = _returnModel.product;
    _statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_status", nil), _returnModel.statusName];
    _dateLabel.text = _returnModel.dateAdded;
}

@end
