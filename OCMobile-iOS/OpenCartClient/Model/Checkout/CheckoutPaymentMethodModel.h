//
//  CheckoutPaymentMethodModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PaymentGateway.h"

@protocol CheckoutPaymentMethodModel
@end

@interface CheckoutPaymentMethodModel : JSONModel

@property(nonatomic) PaymentGatewayType code;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString<Optional> *icon;

@end
