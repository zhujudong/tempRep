//
//  CheckoutModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CheckoutShippingAddressModel.h"
#import "CheckoutProductItemModel.h"
#import "CheckoutShippingMethodModel.h"
#import "CheckoutPaymentMethodModel.h"
#import "CheckoutTotalItemModel.h"
#import "CheckoutCouponModel.h"
#import "PaymentGateway.h"

@interface CheckoutModel : JSONModel

@property(nonatomic) NSInteger addressId;
@property(nonatomic) NSString *shipping;
@property(nonatomic) NSString *shippingMethodName;
@property(nonatomic) PaymentGatewayType payment;
@property(nonatomic) NSString *paymentMethodName;
@property(nonatomic) NSString *coupon;
@property(nonatomic) NSString *voucher;
@property(nonatomic) NSInteger reward;
@property(nonatomic) CheckoutShippingAddressModel<Optional> *address;
@property(nonatomic) NSArray<CheckoutProductItemModel> *products;
@property(nonatomic) NSArray<CheckoutShippingMethodModel> *shippingMethods;
@property(nonatomic) NSArray<CheckoutPaymentMethodModel> *paymentMethods;
@property(nonatomic) NSArray<CheckoutCouponModel> *validCoupons;
@property(nonatomic) NSInteger validRewardsMax;
@property(nonatomic) NSInteger validRewardsTotal;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSArray<CheckoutTotalItemModel> *totals;
@property(nonatomic) NSString<Optional> *totalFormat;

@end
