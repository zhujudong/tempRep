//
//  ProductReviewAllCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewAllCell.h"

@interface ProductReviewAllCell()
@property (strong, nonatomic) UILabel *allReviewLabel;
@end

@implementation ProductReviewAllCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_allReviewLabel) {
            _allReviewLabel = [UILabel new];
            _allReviewLabel.text = NSLocalizedString(@"label_cell_product_review_all", nil);
            _allReviewLabel.font = [UIFont systemFontOfSize:13];
            _allReviewLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];

            [self.contentView addSubview:_allReviewLabel];
            [_allReviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(14);
                make.bottom.equalTo(self.contentView).offset(-14);
                make.centerX.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

@end
