//
//  CheckoutShippingMethodsViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "CheckoutShippingMethodModel.h"

@interface CheckoutShippingMethodsViewController : BaseTableViewController

@property(strong, nonatomic) NSString *currentShippingMethodCode;
@property(strong, nonatomic) NSArray<CheckoutShippingMethodModel> *shippingMethods;

@end
