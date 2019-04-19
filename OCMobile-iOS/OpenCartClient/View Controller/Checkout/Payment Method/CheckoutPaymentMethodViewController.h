//
//  CheckoutPaymentMethodViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "CheckoutPaymentMethodModel.h"
#import "PaymentGateway.h"

@interface CheckoutPaymentMethodViewController : BaseTableViewController

@property(nonatomic) PaymentGatewayType currentPaymentMethodCode;
@property(strong, nonatomic) NSArray<CheckoutPaymentMethodModel> *paymentMethods;

@end
