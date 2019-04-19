//
//  CheckoutCouponViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "CheckoutCouponModel.h"

@interface CheckoutCouponViewController : BaseTableViewController

@property(strong, nonatomic) NSString *currentCouponCode;
@property(strong, nonatomic) NSArray<CheckoutCouponModel> *coupons;

@end
