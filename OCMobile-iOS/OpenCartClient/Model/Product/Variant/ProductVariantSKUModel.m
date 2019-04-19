//
//  ProductVariantSKUModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "ProductVariantSKUModel.h"

@implementation ProductVariantSKUModel

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
