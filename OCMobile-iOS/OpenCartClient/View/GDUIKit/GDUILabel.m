//
//  GDUILabel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDUILabel.h"

@implementation GDUILabel

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)drawTextInRect:(CGRect)rect {

    UIEdgeInsets padding = UIEdgeInsetsMake(_paddingTop, _paddingLeft, _paddingBottom, _paddingRight);

    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, padding)];
}

- (CGSize)intrinsicContentSize {
    CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize];

    intrinsicSuperViewContentSize.height += _paddingTop + _paddingBottom;
    intrinsicSuperViewContentSize.height = ceil(intrinsicSuperViewContentSize.height);

    intrinsicSuperViewContentSize.width += _paddingLeft + _paddingRight;
    intrinsicSuperViewContentSize.width = ceil(intrinsicSuperViewContentSize.width);

    return intrinsicSuperViewContentSize;
}

@end
