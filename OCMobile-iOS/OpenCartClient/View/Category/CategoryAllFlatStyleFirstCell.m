//
//  CategoryAllFlatStyleFirstCell.m
//  YITAYO
//
//  Created by Sam Chen on 24/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryAllFlatStyleFirstCell.h"
#import "GDUILabel.h"

@interface CategoryAllFlatStyleFirstCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) GDUILabel *nameLabel;
@end

@implementation CategoryAllFlatStyleFirstCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        if (!_imageView) {
            _imageView = [UIImageView new];
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            _imageView.clipsToBounds = YES;

            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [GDUILabel new];
            _nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
            _nameLabel.paddingTop = 10;
            _nameLabel.paddingRight = 14;
            _nameLabel.paddingBottom = 10;
            _nameLabel.paddingLeft = 14;
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.textColor = [UIColor whiteColor];
            _nameLabel.layer.cornerRadius = 3;
            _nameLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            _nameLabel.layer.borderWidth = 0.5;
            _nameLabel.clipsToBounds = YES;
            _nameLabel.textAlignment = NSTextAlignmentCenter;

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setCategory:(CategoryFirstLevelItemModel *)category {
    _category = category;
    [_imageView lazyLoad:_category.originalImage];
    _nameLabel.text = _category.name;
}

@end
