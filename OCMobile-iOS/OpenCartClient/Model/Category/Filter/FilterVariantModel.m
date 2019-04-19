//
//  FilterVariantModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterVariantModel.h"

@implementation FilterVariantModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"variant_id",
                                                                  @"name": @"name",
                                                                  @"values": @"values"
                                                                  }];
}

@end
