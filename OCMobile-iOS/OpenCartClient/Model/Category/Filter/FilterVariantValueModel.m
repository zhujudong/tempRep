//
//  FilterVariantValueModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterVariantValueModel.h"

@implementation FilterVariantValueModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"variant_value_id",
                                                                  @"name": @"variant_value_name"
                                                                  }];
}

@end
