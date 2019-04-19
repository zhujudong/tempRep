//
//  ProductReviewReviewCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewReviewCell.h"
#import "HCSStarRatingView.h"

static CGFloat const GUTTER = 10.0;
static CGFloat const AVATAR_IMAGE_WIDTH = 20.0;

@interface ProductReviewReviewCell()
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIView *separatorLine;
@property (strong, nonatomic) HCSStarRatingView *ratingView;
@property (strong, nonatomic) UILabel *nameLabel, *reviewLabel, *timeLabel;
@end

@implementation ProductReviewReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_avatarImageView) {
            _avatarImageView = [UIImageView new];
            _avatarImageView.layer.cornerRadius = AVATAR_IMAGE_WIDTH / 2;
            _avatarImageView.clipsToBounds = YES;

            [self.contentView addSubview:_avatarImageView];
            [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(AVATAR_IMAGE_WIDTH);
                make.top.and.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_avatarImageView);
                make.leading.equalTo(_avatarImageView.mas_trailing).offset(GUTTER);
            }];
        }

        if (!_separatorLine) {
            _separatorLine = [UIView new];
            _separatorLine.backgroundColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1];

            [self.contentView addSubview:_separatorLine];
            [_separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(.5);
                make.top.equalTo(_avatarImageView.mas_bottom).offset(GUTTER);
                make.leading.and.trailing.equalTo(self.contentView);
            }];
        }

        if (!_ratingView) {
            _ratingView = [HCSStarRatingView new];
            _ratingView.maximumValue = 5;
            _ratingView.minimumValue = 1;
            _ratingView.spacing = 0;
            _ratingView.emptyStarImage = [UIImage imageNamed:@"star_empty"];
            _ratingView.filledStarImage = [UIImage imageNamed:@"star"];

            [self.contentView addSubview:_ratingView];
            [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(10);
                make.top.equalTo(_separatorLine.mas_bottom).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_reviewLabel) {
            _reviewLabel = [UILabel new];
            _reviewLabel.textColor = [UIColor colorWithHexString:@"2B2B2B" alpha:1];
            _reviewLabel.font = [UIFont systemFontOfSize:12];
            _reviewLabel.numberOfLines = 0;

            [self.contentView addSubview:_reviewLabel];
            [_reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_ratingView.mas_bottom).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
            }];
        }

        if (!_timeLabel) {
            _timeLabel = [UILabel new];
            _timeLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];
            _timeLabel.font = [UIFont systemFontOfSize:12];

            [self.contentView addSubview:_timeLabel];
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_reviewLabel.mas_bottom).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }

    return self;
}

- (void)setReview:(ProductReviewItemModel *)review {
    _review = review;

    if (_review == nil) {
        return;
    }

    [self.avatarImageView lazyLoad:review.customerAvatar];
    _nameLabel.text = _review.author;
    _ratingView.value = _review.rating;
    _reviewLabel.text = _review.text;
    _timeLabel.text = _review.dateAdded;
}

@end
