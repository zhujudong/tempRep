//
//  PaymentGateway.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/14.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PaymentGatewayType) {
    PaymentGatewayTypeWechat,
    PaymentGatewayTypeAlipay,
    PaymentGatewayTypePaypal,
    PaymentGatewayTypeStripe,
    PaymentGatewayTypeCOD,
    PaymentGatewayTypeBankTransfer,
    PaymentGatewayTypeFreeCheckout,
    PaymentGatewayTypeUnknown,
};

@interface PaymentGateWay : NSObject
+ (PaymentGatewayType)convertFromNSString:(NSString *)string;
+ (NSString *)convertToNSString:(PaymentGatewayType)type;
@end
