//
//  RDVTabBarController+CartNumber.m
//  OpenCartClient
//
//  Created by Sam Chen on 29/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "RDVTabBarController+CartNumber.h"
#import "GDUILabel.h"
#import "Customer.h"

static NSInteger const CART_INDEX = 3;
static CGFloat const PADDING = 3.0;

@implementation RDVTabBarController (CartNumber)

- (void)updateCartNumber {
    NSLog(@"updateCartNumber");
    
    //Remove first
    for (UIView *subView in self.tabBar.subviews) {
        if (subView.tag == 100) {
            [subView removeFromSuperview];
        }
    }
    
    NSInteger cartNumber = [[Customer sharedInstance] cartNumber];
    if (cartNumber <= 0) {
        return;
    }
    
    //Background
    UIView *numberBackground = [[UIView alloc] initWithFrame:CGRectZero];
    numberBackground.tag = 100;
    numberBackground.backgroundColor = CONFIG_PRIMARY_COLOR;
    numberBackground.layer.cornerRadius = 5.;
    numberBackground.clipsToBounds = YES;
    
    //Label
    UILabel *numberLabel = [[UILabel alloc] init];
    
    if (cartNumber > 99) {
        numberLabel.text = [NSString stringWithFormat:@"%d+", 99];
    } else {
        numberLabel.text = [NSString stringWithFormat:@"%ld", (long)cartNumber];
    }
    
    numberLabel.font = [UIFont systemFontOfSize:9.];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [numberLabel sizeToFit];
    
    numberLabel.frame = CGRectMake(PADDING, 0, MAX(numberLabel.frame.size.width, 10.), numberLabel.frame.size.height);
    [numberBackground addSubview:numberLabel];
    
    //Position
    CGFloat x = ceilf((self.tabBar.frame.size.width / self.tabBar.items.count * CART_INDEX) + (self.tabBar.frame.size.width / self.tabBar.items.count * .5) + 5.);
    CGFloat y = ceilf(0.1 * self.tabBar.frame.size.height);
    numberBackground.frame = CGRectMake(x, y, numberLabel.frame.size.width + PADDING * 2, numberLabel.frame.size.height);
    
    [self.tabBar addSubview:numberBackground];
}

@end
