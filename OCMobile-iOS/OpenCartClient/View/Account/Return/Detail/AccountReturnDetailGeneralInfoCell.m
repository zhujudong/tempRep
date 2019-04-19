//
//  AccountReturnDetailGeneralInfoCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnDetailGeneralInfoCell.h"

static CGFloat const GUTTER=  10.0;

@interface AccountReturnDetailGeneralInfoCell()
@property (strong, nonatomic) UILabel *productNameLabel, *orderIdLabel, *orderDateLabel, *contactLabel, *reasonLabel, *dateLabel;
@end

@implementation AccountReturnDetailGeneralInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_productNameLabel) {
            _productNameLabel = [UILabel new];
            _productNameLabel.font = [UIFont systemFontOfSize:12];
            _productNameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_productNameLabel];
            [_productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_orderIdLabel) {
            _orderIdLabel = [UILabel new];
            _orderIdLabel.font = [UIFont systemFontOfSize:12];
            _orderIdLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_orderIdLabel];
            [_orderIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_productNameLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_productNameLabel);
            }];
        }

        if (!_orderDateLabel) {
            _orderDateLabel = [UILabel new];
            _orderDateLabel.font = [UIFont systemFontOfSize:12];
            _orderDateLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_orderDateLabel];
            [_orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_orderIdLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_productNameLabel);
            }];
        }

        if (!_contactLabel) {
            _contactLabel = [UILabel new];
            _contactLabel.font = [UIFont systemFontOfSize:12];
            _contactLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_contactLabel];
            [_contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_orderDateLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_productNameLabel);
            }];
        }

        if (!_reasonLabel) {
            _reasonLabel = [UILabel new];
            _reasonLabel.font = [UIFont systemFontOfSize:12];
            _reasonLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_reasonLabel];
            [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_contactLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_productNameLabel);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_reasonLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_productNameLabel);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }

    return self;
}

- (void)setReturnModel:(AccountReturnInfoModel *)returnModel {
    _productNameLabel.text = returnModel.product;
    _orderIdLabel.text = [NSString stringWithFormat:NSLocalizedString(@"order_number", nil), returnModel.orderId];
    _orderDateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_order_date", nil), returnModel.dateOrdered];
    _contactLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_contact_with_phone", nil), returnModel.firstname, returnModel.telephone];
    _reasonLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_return_reason", nil), returnModel.reasonName];
    _dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_return_date_added", nil), returnModel.dateAdded];
}

@end
