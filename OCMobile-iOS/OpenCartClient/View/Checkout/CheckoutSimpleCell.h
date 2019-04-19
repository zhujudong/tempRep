//
//  CheckoutSimpleCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CheckoutSimpleCell @"CheckoutSimpleCell"

@interface CheckoutSimpleCell : UITableViewCell

- (void)setTitle:(NSString *)title value:(NSString *)value;

@end
