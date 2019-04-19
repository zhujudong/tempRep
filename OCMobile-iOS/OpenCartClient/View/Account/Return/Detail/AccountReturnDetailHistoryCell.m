//
//  AccountReturnDetailHistoryCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnDetailHistoryCell.h"

static CGFloat const GUTTER=  10.0;

@interface AccountReturnDetailHistoryCell()
@property (strong, nonatomic) UILabel *dateLabel, *messageLabel, *statusLabel;
@end

@implementation AccountReturnDetailHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_dateLabel) {
            _dateLabel = [UILabel new];
            _dateLabel.font = [UIFont systemFontOfSize:12];
            _dateLabel.textColor = [UIColor colorWithHexString:@"7A7A7A" alpha:1];

            [self.contentView addSubview:_dateLabel];
            [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_messageLabel) {
            _messageLabel = [UILabel new];
            _messageLabel.font = [UIFont systemFontOfSize:12];
            _messageLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];

            [self.contentView addSubview:_messageLabel];
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_dateLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_dateLabel);
            }];
        }

        if (!_statusLabel) {
            _statusLabel = [UILabel new];
            _statusLabel.font = [UIFont systemFontOfSize:12];
            _statusLabel.textColor = [UIColor colorWithHexString:@"7A7A7A" alpha:1];

            [self.contentView addSubview:_statusLabel];
            [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_messageLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(_dateLabel);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }

    return self;
}

- (void)setHistory:(AccountReturnInfoHistoryModel *)history {
    _history = history;

    _dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_date", nil), _history.dateAdded];
    _messageLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_return_message", nil), _history.comment];
    _statusLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_status", nil), _history.statusName];
}

@end
