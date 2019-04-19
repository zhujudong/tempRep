//
//  CustomSplashImageView.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CustomSplashImageView.h"

@interface CustomSplashImageView()
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation CustomSplashImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;

    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;

        [self addSubview:_imageView];
    }

    return self;
}

- (void)setImage:(UIImage *)image {
    _imageView.image = image;
}

@end
