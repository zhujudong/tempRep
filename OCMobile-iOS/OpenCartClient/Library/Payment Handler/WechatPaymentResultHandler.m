//
//  WechatPaymentResultHandler.m
//  OpenCartClient
//
//  Created by Sam Chen on 13/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "WechatPaymentResultHandler.h"

@implementation WechatPaymentResultHandler

-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        self.success = NO;
        NSLog(@"Wechat payment result: code = %d, error = %@", resp.errCode, resp.errStr);

        //返回resp.errCode==0说明支付成功,  -1是支付错误 ，  -2是用户取消了支付
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                self.success = YES;
                break;
            case -1:
                self.message = NSLocalizedString(@"error_payment_result_failed", nil);
                break;
            case -2:
                self.message = NSLocalizedString(@"error_payment_result_canceled", nil);
                break;
            default:
                self.message = [NSString stringWithFormat:@"Wechat payment failed: code = %d, error = %@", resp.errCode, resp.errStr];
                break;
        }

        [self presentPaymentResultVCIfNeeded];
    }
}


@end
