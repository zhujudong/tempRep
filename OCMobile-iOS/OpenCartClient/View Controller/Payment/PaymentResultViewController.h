//
//  PaymentResultViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 12/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PaymentResultViewController : BaseViewController
@property (assign, nonatomic) BOOL isOnlinePayment;
@property (assign, nonatomic) BOOL paymentSuccess;
@end
