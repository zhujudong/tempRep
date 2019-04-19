//
//  CategoryAllCollectionViewCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryAllCollectionViewCell.h"

@implementation CategoryAllCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];

            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.trailing.equalTo(self);
                make.height.equalTo(_imageView.mas_width);
            }];
        }
        
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] init];
            _nameLabel.numberOfLines = 1;
            _nameLabel.textColor = [UIColor blackColor];
            _nameLabel.font = [UIFont systemFontOfSize:12];
            _nameLabel.textAlignment = NSTextAlignmentCenter;

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_bottom).offset(5);
                make.leading.equalTo(self).offset(5);
                make.trailing.and.bottom.equalTo(self).offset(-5);
            }];
        }
    }

    return self;
}

- (void)setImage:(NSString *)image name:(NSString *)name {
    [_imageView lazyLoad:image];
    _nameLabel.text = name;
}
@end
