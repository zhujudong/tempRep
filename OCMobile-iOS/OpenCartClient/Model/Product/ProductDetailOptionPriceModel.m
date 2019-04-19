//
//  ProductDetailOptionPriceModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 05/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ProductDetailOptionPriceModel.h"

@implementation ProductDetailOptionPriceModel
+(JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}
@end
