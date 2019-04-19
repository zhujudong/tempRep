//
//  AccountOrderExpressesModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderExpressesModel.h"

@implementation AccountOrderExpressesModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"expresses": @"tracks",
                                                                  }];
}

@end
