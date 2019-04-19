//
//  AccountRewardItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountRewardItemCell.h"

@interface  AccountRewardItemCell()
@property (strong, nonatomic) UILabel *titleLabel, *dateLabel, *pointsLabel;
@end

@implementation AccountRewardItemCell

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
                make.top.and.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:13];
            _dateLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(10);
                make.leading.equalTo(_titleLabel);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_pointsLabel) {
            _pointsLabel = [UILabel new];
            _pointsLabel.font = [UIFont boldSystemFontOfSize:20];
            _pointsLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_pointsLabel];
            [_pointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-16);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }
    
    return self;
}

- (void)setReward:(AccountRewardHistoryModel *)reward {
    _reward = reward;

    _titleLabel.text = _reward.name;
    _dateLabel.text = _reward.dateAdded;
    _pointsLabel.text = [NSString stringWithFormat:@"%ld", (long)reward.points];

    if (_reward.points > 0) {
        _pointsLabel.textColor = CONFIG_PRIMARY_COLOR;
    } else {
        _pointsLabel.textColor = [UIColor colorWithHexString:@"7a7a7a" alpha:1.];
    }
}

@end
