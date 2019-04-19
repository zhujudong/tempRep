//
//  AccountOrderExpressInfoCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderExpressInfoCell.h"

@interface AccountOrderExpressInfoCell()
@property (strong, nonatomic) UILabel *nameLabel, *numberLabel;
@end

@implementation AccountOrderExpressInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:13];
            _nameLabel.textColor = [UIColor colorWithHexString:@"5A5859" alpha:1];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(12);
                make.leading.equalTo(self.contentView).offset(20);
                make.trailing.equalTo(self.contentView).offset(-20);
            }];
        }

        if (!_numberLabel) {
            _numberLabel = [UILabel new];
            _numberLabel.font = [UIFont systemFontOfSize:13];
            _numberLabel.textColor = [UIColor colorWithHexString:@"5A5859" alpha:1];

            [self.contentView addSubview:_numberLabel];
            [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(12);
                make.leading.and.trailing.equalTo(_nameLabel);
                make.bottom.equalTo(self.contentView).offset(-12);
            }];
        }
    }

    return self;
}

- (void)setExpressModel:(AccountOrderExpressModel *)expressModel {
    _expressModel = expressModel;

    _nameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_shipped_by", nil), _expressModel.name];
    _numberLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_shipment_track_id", nil), _expressModel.expressNo];
}
@end
