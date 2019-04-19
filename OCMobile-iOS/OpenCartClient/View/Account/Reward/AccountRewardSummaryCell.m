//
//  AccountRewardSummaryCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountRewardSummaryCell.h"

@implementation AccountRewardSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        self.backgroundColor = CONFIG_PRIMARY_COLOR;

        if (!_titleLabel) {
            _titleLabel = [UILabel new];
            _titleLabel.text = NSLocalizedString(@"label_cell_account_reward_summary_title", nil);
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.font = [UIFont systemFontOfSize:18];

            [self.contentView addSubview:_titleLabel];
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(25);
                make.leading.equalTo(self.contentView).offset(10);
            }];
        }
        
        if (!_rewardTotalLabel) {
            _rewardTotalLabel = [UILabel new];
            _rewardTotalLabel.text = @"0";
            _rewardTotalLabel.textColor = [UIColor whiteColor];
            _rewardTotalLabel.font = [UIFont systemFontOfSize:48];

            [self.contentView addSubview:_rewardTotalLabel];
            [_rewardTotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel).offset(30);
                make.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-15);
            }];
        }
    }

    return self;
}

@end
