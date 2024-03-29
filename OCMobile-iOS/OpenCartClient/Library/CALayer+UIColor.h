//
//  CALayer+UIColor.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/22/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer(UIColor)

// This assigns a CGColor to borderColor.
@property(nonatomic, assign) UIColor* borderUIColor;

@end