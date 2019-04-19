//
//  AccountOrderExpressItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderExpressItemCell.h"

static CGFloat const DOT_WIDTH = 7.0;
static CGFloat const LINE_WIDTH = 0.5;
static CGFloat const DOT_LINE_SPACING = 2.0;

@interface AccountOrderExpressItemCell ()
@property (strong, nonatomic) UILabel *stopLabel, *timeLabel;
@property (strong, nonatomic) UIView *dotView, *lineView;
@end

@implementation AccountOrderExpressItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_stopLabel) {
            _stopLabel = [UILabel new];
            _stopLabel.numberOfLines = 0;
            _stopLabel.font = [UIFont systemFontOfSize:12];
            _stopLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];

            [self.contentView addSubview:_stopLabel];
            [_stopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(self.contentView).offset(70);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_timeLabel) {
            _timeLabel = [UILabel new];
            _timeLabel.numberOfLines = 0;
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor colorWithHexString:@"909090" alpha:1];

            [self.contentView addSubview:_timeLabel];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_stopLabel.mas_bottom).offset(8);
                make.leading.and.trailing.equalTo(_stopLabel);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_dotView) {
            _dotView = [UIView new];
            _dotView.layer.cornerRadius = DOT_WIDTH / 2;
            _dotView.clipsToBounds = YES;

            [self.contentView addSubview:_dotView];
        }

        if (!_lineView) {
            _lineView = [UIView new];
            _lineView.backgroundColor = [UIColor colorWithHexString:@"cacaca" alpha:1];

            [self.contentView addSubview:_lineView];
        }
    }

    return self;
}

- (void)setTraceModel:(AccountOrderExpressTraceModel *)traceModel {
    _traceModel = traceModel;

    _stopLabel.text = _traceModel.station;
    _timeLabel.text = _traceModel.time;
}

- (void)setDotStyleFirst {
    _dotView.backgroundColor = CONFIG_PRIMARY_COLOR;

    [_dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DOT_WIDTH, DOT_WIDTH));
        make.leading.equalTo(self.contentView).offset(30);
        make.centerY.equalTo(self.contentView);
    }];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LINE_WIDTH);
        make.centerX.equalTo(_dotView);
        make.top.equalTo(_dotView.mas_bottom).offset(DOT_LINE_SPACING);
        make.bottom.equalTo(self);
    }];
}

- (void)setDotStyleMiddle {
    _dotView.backgroundColor = [UIColor colorWithHexString:@"cacaca" alpha:1];

    [_dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DOT_WIDTH, DOT_WIDTH));
        make.leading.equalTo(self.contentView).offset(30);
        make.centerY.equalTo(self.contentView);
    }];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LINE_WIDTH);
        make.centerX.equalTo(_dotView);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setDotStyleLast {
    _dotView.backgroundColor = [UIColor colorWithHexString:@"cacaca" alpha:1];

    [_dotView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DOT_WIDTH, DOT_WIDTH));
        make.leading.equalTo(self.contentView).offset(30);
        make.centerY.equalTo(self.contentView);
    }];

    [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(LINE_WIDTH);
        make.centerX.equalTo(_dotView);
        make.top.equalTo(self);
        make.bottom.equalTo(_dotView.mas_top).offset(-DOT_LINE_SPACING);
    }];
}

@end
