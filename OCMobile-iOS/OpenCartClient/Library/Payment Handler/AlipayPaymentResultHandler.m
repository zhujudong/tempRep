//
//  AlipayPaymentResultHandler.m
//  OpenCartClient
//
//  Created by Sam Chen on 13/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AlipayPaymentResultHandler.h"

@implementation AlipayPaymentResultHandler

- (void)processResult:(NSDictionary *)result {
    NSInteger status = [result[@"resultStatus"] integerValue];
    NSLog(@"Alipay resultStatus = %ld", (long)status);
    self.success = NO;

    switch (status) {
        case 9000: // Success
            self.success = YES;
            break;
        case 8000: // Processing, make it a success
            self.success = YES;
            break;
        case 4000: // Failed
            self.message = NSLocalizedString(@"error_payment_result_failed", nil);
            break;
        case 6001: // Canceled
            self.message = NSLocalizedString(@"error_payment_result_canceled", nil);
            break;
        case 6002: // No network
            self.message = NSLocalizedString(@"error_payment_result_no_network", nil);
            break;
        default:
            self.message = NSLocalizedString(@"error_payment_result_general", nil);
            break;
    }

    [self presentPaymentResultVCIfNeeded];
}

@end
