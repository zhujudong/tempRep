//
//  AccountUnreviewedListCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountUnreviewedListCell.h"

@interface AccountUnreviewedListCell()
@property (strong, nonatomic) UIImageView *thumbView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *reviewButtonLabel;
@end

@implementation AccountUnreviewedListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_thumbView) {
            _thumbView = [UIImageView new];
            [self.contentView addSubview:_thumbView];
            [_thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(100);
                make.top.and.leading.equalTo(self.contentView).offset(10);
                make.bottom.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.numberOfLines = 0;
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(10);
                make.leading.equalTo(_thumbView.mas_trailing).offset(10);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }

        if (!_reviewButtonLabel) {
            _reviewButtonLabel = [UILabel new];
            _reviewButtonLabel.text = NSLocalizedString(@"label_cell_account_unreviewed", nil);
            _reviewButtonLabel.font = [UIFont systemFontOfSize:12];
            _reviewButtonLabel.backgroundColor = CONFIG_PRIMARY_COLOR;
            _reviewButtonLabel.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
            _reviewButtonLabel.clipsToBounds = YES;
            _reviewButtonLabel.textColor = [UIColor whiteColor];
            _reviewButtonLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_reviewButtonLabel];
            [_reviewButtonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(80, 34));
                make.trailing.and.bottom.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setProduct:(AccountUnreviewedProductModel *)product {
    _product = product;

    [_thumbView lazyLoad:_product.image];
    _nameLabel.text = _product.name;
}

@end
