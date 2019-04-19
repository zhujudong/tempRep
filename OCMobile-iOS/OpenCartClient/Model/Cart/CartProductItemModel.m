//
//  CartProductItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CartProductItemModel.h"

@implementation CartProductItemModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (NSString *)name {
    if ([System isDebug]) {
        return [NSString stringWithFormat:@"[product_id: %ld] %@", (long)_productId, _name];
    }
    return _name;
}

@end
