//
//  RatingStarSelectorCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "RatingStarSelectorCell.h"

@implementation RatingStarSelectorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
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

        if (!_ratingView) {
            _ratingView = [HCSStarRatingView new];
            _ratingView.emptyStarImage = [UIImage imageNamed:@"star_empty"];
            _ratingView.filledStarImage = [UIImage imageNamed:@"star"];
            _ratingView.allowsHalfStars = NO;
            _ratingView.maximumValue = 5;
            _ratingView.minimumValue = 1;
            _ratingView.value = 5;
            _ratingView.spacing = 0;
            [_ratingView addTarget:self action:@selector(ratingValueChanged) forControlEvents:UIControlEventValueChanged];

            [self.contentView addSubview:_ratingView];
            [_ratingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-20);
                make.centerY.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(140, 20));
            }];
        }
    }

    return self;
}

- (void)ratingValueChanged {
    if (self.ratingValueChangedBlock) {
        self.ratingValueChangedBlock(_ratingView.value);
    }
}

@end
