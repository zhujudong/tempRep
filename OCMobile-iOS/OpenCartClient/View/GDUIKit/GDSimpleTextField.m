//
//  GDSimpleTextField.m
//  OpenCartClient
//
//  Created by Sam Chen on 02/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDSimpleTextField.h"

@implementation GDSimpleTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = .5;
        self.layer.borderColor = [UIColor colorWithHexString:@"C8C6CC" alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14.0];
    }

    return self;
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
