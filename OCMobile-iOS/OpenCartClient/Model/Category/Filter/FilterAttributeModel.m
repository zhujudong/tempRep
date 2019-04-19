//
//  FilterAttributeModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterAttributeModel.h"

@implementation FilterAttributeModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"name": @"name",
                                                                  @"id": @"attribute_id",
                                                                  @"values": @"values"
                                                                  }];
}

@end
