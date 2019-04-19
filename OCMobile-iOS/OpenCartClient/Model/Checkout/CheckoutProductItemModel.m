//
//  CheckoutProductItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutProductItemModel.h"

@implementation CheckoutProductItemModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (NSString *)name {
    if ([System isDebug]) {
        return [NSString stringWithFormat:@"[cart_id: %@] %@", _cartId, _name];
    }
    return _name;
}

@end
