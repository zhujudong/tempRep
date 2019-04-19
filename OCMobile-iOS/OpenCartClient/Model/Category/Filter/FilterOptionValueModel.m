//
//  FilterOptionValueModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterOptionValueModel.h"

@implementation FilterOptionValueModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"id": @"option_value_id",
                                                                  @"name": @"option_value_name"
                                                                  }];
}

@end
