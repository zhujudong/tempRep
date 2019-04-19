//
//  FilterOptionModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterOptionModel.h"

@implementation FilterOptionModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"option_id",
                                                                  @"name": @"name",
                                                                  @"values": @"values"
                                                                  }];
}

@end
