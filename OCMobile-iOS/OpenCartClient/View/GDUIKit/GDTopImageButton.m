//
//  GDTopImageButton.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDTopImageButton.h"

@implementation GDTopImageButton

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect imageFrame = self.imageView.frame;
    CGRect titleFrame = self.titleLabel.frame;

    imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width) / 2.;
    imageFrame.origin.y = (self.bounds.size.height - (imageFrame.size.height + _spacing + titleFrame.size.height)) / 2;

    self.imageView.frame = imageFrame;

    titleFrame.origin.x = (self.bounds.size.width - titleFrame.size.width) / 2.;
    titleFrame.origin.y = imageFrame.origin.y + imageFrame.size.height + _spacing;

    self.titleLabel.frame = titleFrame;
}

@end
