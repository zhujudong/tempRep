//
//  GDStrikeThroughLabel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/19/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "GDStrikeThroughLabel.h"

@implementation GDStrikeThroughLabel

- (void)setText:(NSString *)text {
    [super setText:text];

    if (text.length > 0) {
        NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};

        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:self.text.length > 0 ? self.text : @"" attributes:attributeDic];

        self.attributedText = attributedText;
    }
}

@end
