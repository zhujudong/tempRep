//
//  CheckoutPaymentMethodModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutPaymentMethodModel.h"

@implementation CheckoutPaymentMethodModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (void)setCodeWithNSString:(NSString *)string {
    self.code = [PaymentGateWay convertFromNSString:string];
}
@end
