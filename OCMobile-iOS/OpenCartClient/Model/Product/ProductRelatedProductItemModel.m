//
//  ProductRelatedProductItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 04/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ProductRelatedProductItemModel.h"

@implementation ProductRelatedProductItemModel

+(JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
