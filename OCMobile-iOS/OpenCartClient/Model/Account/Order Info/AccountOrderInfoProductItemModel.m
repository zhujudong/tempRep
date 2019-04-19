//
//  AccountOrderInfoProductItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderInfoProductItemModel.h"

@implementation AccountOrderInfoProductItemModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"orderProductId": @"order_product_id",
                                                                  @"productId": @"product_id",
                                                                  @"name": @"name",
                                                                  @"image": @"image",
                                                                  @"option": @"option_values",
                                                                  @"price": @"price_format",
                                                                  @"quantity": @"quantity"
                                                                  }];
}

@end
