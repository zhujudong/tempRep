//
//  PaymentParamStripeModel.m
//  afterschoollol
//
//  Created by Sam Chen on 14/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PaymentParamStripeModel.h"

@implementation PaymentParamStripeModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"currency": @"currency",
                                                                  @"saveCards": @"save_cards",
                                                                  @"subject": @"subject",
                                                                  @"total": @"total"
                                                                  }];
}

@end
