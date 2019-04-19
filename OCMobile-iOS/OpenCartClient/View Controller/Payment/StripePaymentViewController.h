//
//  StripePaymentViewController.h
//  afterschoollol
//
//  Created by Sam Chen on 08/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PaymentParamStripeModel.h"

@protocol StripePaymentDelegate <NSObject>
@required
- (void)stripePaymentFinished:(BOOL)success;
@end

@interface StripePaymentViewController : BaseViewController
@property (strong, nonatomic) NSString * orderId;
@property (strong, nonatomic) PaymentParamStripeModel *stripe;
@property (nonatomic, assign) id<StripePaymentDelegate> delegate;
@end
