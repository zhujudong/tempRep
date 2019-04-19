//
//  AccountSimpleCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountSimpleCell.h"

@interface AccountSimpleCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation AccountSimpleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.separatorInset = UIEdgeInsetsZero;

        if (!_iconImageView) {
            _iconImageView = [UIImageView new];

            [self.contentView addSubview:_iconImageView];
            [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(18, 18)).priorityHigh();
                make.top.equalTo(self.contentView).offset(14);
                make.bottom.equalTo(self.contentView).offset(-14);
                make.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:13];
            _titleLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_iconImageView.mas_trailing).offset(12);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setImage:(NSString *)image title:(NSString *)title {
    _iconImageView.image = [UIImage imageNamed:image];
    _titleLabel.text = title;
}
@end;
