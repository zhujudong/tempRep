//
//  CheckoutCouponItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutCouponModel.h"

#define kCellIdentifier_CheckoutCouponItemCell @"CheckoutCouponItemCell"

@interface CheckoutCouponItemCell : UITableViewCell
@property (strong, nonatomic) CheckoutCouponModel *coupon;

- (void)setImageHighlighted:(BOOL)highlighted;
@end
