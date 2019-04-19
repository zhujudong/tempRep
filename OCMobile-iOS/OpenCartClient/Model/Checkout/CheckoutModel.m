//
//  CheckoutModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutModel.h"

@implementation CheckoutModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"addressId": @"address_id",
                                                                  @"shipping": @"shipping",
                                                                  @"shippingMethodName": @"shipping_method_name",
                                                                  @"payment": @"payment",
                                                                  @"paymentMethodName": @"payment_method_name",
                                                                  @"coupon": @"coupon",
                                                                  @"voucher": @"voucher",
                                                                  @"reward": @"reward",
                                                                  @"address": @"address",
                                                                  @"products": @"products",
                                                                  @"shippingMethods": @"shipping_methods",
                                                                  @"paymentMethods": @"payment_methods",
                                                                  @"validCoupons": @"valid_coupons",
                                                                  @"validRewardsMax": @"valid_rewards.max_points",
                                                                  @"validRewardsTotal": @"valid_rewards.valid_points",
                                                                  @"totals": @"order_totals",
                                                                  @"totalFormat": @"total_format",
                                                                  }];
}

- (void)setPaymentWithNSString:(NSString *)string {
    self.payment = [PaymentGateWay convertFromNSString:string];
}

@end
