//
//  VariantValueModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "VariantValueModel.h"

@implementation VariantValueModel

+ (JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"variant_value_id",
                                                                  @"name": @"name",
                                                                  @"image": @"image"
                                                                  }];
}

@end
