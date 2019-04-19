//
//  LabelWithDescriptionCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "LabelWithDescriptionCell.h"

@implementation LabelWithDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_label) {
            _label = [UILabel new];
            _label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_descriptionLabel) {
            _descriptionLabel = [UILabel new];
            _descriptionLabel.font = [UIFont systemFontOfSize:12];
            _descriptionLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];

            [self.contentView addSubview:_descriptionLabel];
            [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setPlaceholder:(NSString *)text description:(NSString *)descriptionText {
    _label.text = text;
    _descriptionLabel.text = descriptionText;
}

@end
