//
//  GDUILabel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDUILabel : UILabel

//Set padding value
@property (nonatomic, assign) IBInspectable CGFloat paddingTop;
@property (nonatomic, assign) IBInspectable CGFloat paddingLeft;
@property (nonatomic, assign) IBInspectable CGFloat paddingBottom;
@property (nonatomic, assign) IBInspectable CGFloat paddingRight;

@end
