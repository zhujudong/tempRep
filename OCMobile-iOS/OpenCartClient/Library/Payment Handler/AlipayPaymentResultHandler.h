//
//  AlipayPaymentResultHandler.h
//  OpenCartClient
//
//  Created by Sam Chen on 13/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PaymentResultHandler.h"

@interface AlipayPaymentResultHandler : PaymentResultHandler
- (void)processResult:(NSDictionary *)result;
@end
