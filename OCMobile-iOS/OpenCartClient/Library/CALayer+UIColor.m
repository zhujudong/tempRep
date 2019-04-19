//
//  CALayer+UIColor.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/22/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CALayer+UIColor.h"

@implementation CALayer(UIColor)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
