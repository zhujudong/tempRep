//
//  ProductReviewItemCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/15/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewItemCell.h"

static CGFloat const GUTTER = 10.0;

@interface ProductReviewItemCell()
@property (strong, nonatomic) HCSStarRatingView *ratingView;
@property (strong, nonatomic) UILabel *nameLabel, *reviewLabel;
@end

@implementation ProductReviewItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

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
                make.top.equalTo(self.contentView).offset(GUTTER);
                make.leading.equalTo(self.contentView).offset(GUTTER);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:10];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-GUTTER);
                make.centerY.equalTo(_ratingView);
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
                make.leading.equalTo(_ratingView);
                make.trailing.equalTo(_nameLabel);
                make.bottom.equalTo(self.contentView).offset(-GUTTER);
            }];
        }
    }

    return self;
}

- (void)setReview:(ProductReviewItemModel *)review {
    _review = review;

    _ratingView.value = _review.rating;
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@", _review.author, _review.dateAdded];
    _reviewLabel.text = _review.text;
}

@end
