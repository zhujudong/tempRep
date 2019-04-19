//
//  PaymentConnectViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 11/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PaymentConnectViewController : BaseViewController

@property (nonatomic) BOOL isNewOrder;
@property (strong, nonatomic) NSString *estimatedTotalFormat;
@property (strong, nonatomic) NSString *estimatedPaymentMethodName;
@property (strong, nonatomic) NSDictionary *paymentDict;

@end
