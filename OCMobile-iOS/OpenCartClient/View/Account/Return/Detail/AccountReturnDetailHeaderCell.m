//
//  AccountReturnDetailHeaderCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnDetailHeaderCell.h"

@interface AccountReturnDetailHeaderCell()
@property (strong, nonatomic) UILabel *titleLabel, *subtitleLabel;
@end

@implementation AccountReturnDetailHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:14];
            _titleLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(12);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_subtitleLabel) {
            _subtitleLabel = [UILabel new];
            _subtitleLabel.font = [UIFont systemFontOfSize:12];
            _subtitleLabel.textColor = [UIColor colorWithHexString:@"E4393C" alpha:1];

            [self.contentView addSubview:_subtitleLabel];
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
    _titleLabel.text = title;
    _subtitleLabel.text = subtitle;
}
@end
