//
//  ProductVariantSKUCurrentModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 07/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "ProductVariantSKUCurrentModel.h"

@implementation ProductVariantSKUCurrentModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"variant_id",
                                                                  @"valueId": @"variant_value_id"
                                                                  }];
}
@end
