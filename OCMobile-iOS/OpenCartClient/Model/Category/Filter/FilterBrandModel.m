//
//  FilterBrandModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterBrandModel.h"

@implementation FilterBrandModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"name": @"name",
                                                                  @"image": @"image",
                                                                  @"id": @"manufacturer_id",
                                                                  }];
}

@end
