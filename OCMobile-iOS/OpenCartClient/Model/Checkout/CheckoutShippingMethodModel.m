//
//  CheckoutShippingMethodModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingMethodModel.h"

@implementation CheckoutShippingMethodModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"code": @"code",
                                                                  @"costFormat": @"cost_format",
                                                                  @"title": @"method_title"}];
}

@end
