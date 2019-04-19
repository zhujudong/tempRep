//
//  ProductDetailOptionValueModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductDetailOptionValueModel.h"

@implementation ProductDetailOptionValueModel

+(JSONKeyMapper*) keyMapper {
    //return [JSONKeyMapper mapperForSnakeCase];

    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"productOptionValueId": @"product_option_value_id",
                                                                  @"name": @"option_value_name"
                                                                  }];
}

@end
