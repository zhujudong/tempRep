//
//  UIColor+fromHex.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(fromHex)

+(UIColor *)colorWithHexString:(NSString*)hexValue alpha:(CGFloat)alpha;

@end
