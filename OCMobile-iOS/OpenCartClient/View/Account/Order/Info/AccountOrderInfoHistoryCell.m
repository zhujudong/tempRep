//
//  AccountOrderInfoHistoryCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoHistoryCell.h"

@interface AccountOrderInfoHistoryCell()
@property (strong, nonatomic) UILabel *dateLabel, *orderStatusLabel, *commentLabel;
@end

@implementation AccountOrderInfoHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.separatorInset = UIEdgeInsetsZero;
//        self.layoutMargins = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_dateLabel) {
            _dateLabel = [[UILabel alloc] init];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.equalTo(self.contentView).offset(10);
            }];
        }

        if (!_orderStatusLabel) {
            _orderStatusLabel = [[UILabel alloc] init];
            _orderStatusLabel.font = [UIFont systemFontOfSize:12];
            _orderStatusLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
            [self.contentView addSubview:_orderStatusLabel];
            [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(_dateLabel);
            }];
        }

        if (!_commentLabel) {
            _commentLabel = [[UILabel alloc] init];
            _commentLabel.font = [UIFont systemFontOfSize:12];
            _commentLabel.textColor = [UIColor colorWithHexString:@"777777" alpha:1];
            [self.contentView addSubview:_commentLabel];
            [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(10);
                make.leading.equalTo(_dateLabel);
                make.trailing.equalTo(self.contentView).offset(-10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setHistory:(AccountOrderInfoHistoryItemModel *)history {
    _history = history;
    _dateLabel.text = _history.dateAdded;
    _orderStatusLabel.text = _history.statusName;
    _commentLabel.text = _history.comment.length ? _history.comment : NSLocalizedString(@"text_no_comment", nil);
}

@end
