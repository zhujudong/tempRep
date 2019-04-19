//
//  PaymentGatewayType.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/14.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "PaymentGateway.h"

@implementation PaymentGateWay

+ (PaymentGatewayType)convertFromNSString:(NSString *)string {
    if ([string containsString:@"wechat"]) {
        return PaymentGatewayTypeWechat;
    } else if ([string containsString:@"alipay"]) {
        return PaymentGatewayTypeAlipay;
    } else if ([string isEqualToString:@"cod"]) {
        return PaymentGatewayTypeCOD;
    } else if ([string containsString:@"paypal"]) {
        return PaymentGatewayTypePaypal;
    } else if ([string isEqualToString:@"stripe"]) {
        return PaymentGatewayTypeStripe;
    } else if ([string isEqualToString:@"bank_transfer"]) {
        return PaymentGatewayTypeBankTransfer;
    } else if ([string isEqualToString:@"free_checkout"]) {
        return PaymentGatewayTypeFreeCheckout;
    } else {
        return PaymentGatewayTypeUnknown;
    }
}

+ (NSString *)convertToNSString:(PaymentGatewayType)type {
    switch (type) {
        case PaymentGatewayTypeWechat:
            return @"wechat_pay";
        case PaymentGatewayTypeAlipay:
            return @"alipay";
        case PaymentGatewayTypeCOD:
            return @"cod";
        case PaymentGatewayTypePaypal:
            return @"paypal_express";
        case PaymentGatewayTypeStripe:
            return @"stripe";
        case PaymentGatewayTypeBankTransfer:
            return @"bank_transfer";
        case PaymentGatewayTypeFreeCheckout:
            return @"free_checkout";
        default:
            return @"unknown";
    }
}
@end
