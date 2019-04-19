//
//  CheckoutPaymentWeChatModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutPaymentWeChatModel.h"

@implementation CheckoutPaymentWeChatModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"appId": @"appid",
                                                                  @"partnerId": @"partnerid",
                                                                  @"prepayId": @"prepayid",
                                                                  @"package": @"package",
                                                                  @"nonceStr": @"noncestr",
                                                                  @"timestamp": @"timestamp",
                                                                  @"sign": @"sign",
                                                                  }];
}

@end
