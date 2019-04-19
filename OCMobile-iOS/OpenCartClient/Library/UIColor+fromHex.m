//
//  UIColor+fromHex.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

@implementation UIColor (fromHex)

+(UIColor*)colorWithHexString:(NSString *)hexValue alpha:(CGFloat)alpha {
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;

    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexValue];

    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];

    return color;
}

@end
