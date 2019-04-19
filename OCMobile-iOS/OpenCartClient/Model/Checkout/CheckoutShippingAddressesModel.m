//
//  CheckoutShippingAddressesModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutShippingAddressesModel.h"

@implementation CheckoutShippingAddressesModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
