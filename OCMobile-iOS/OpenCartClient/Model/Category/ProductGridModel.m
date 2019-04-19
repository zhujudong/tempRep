//
//  ProductGridModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductGridModel.h"

@implementation ProductGridModel

+ (JSONKeyMapper *) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"currentPage": @"current_page",
                                                                  @"lastPage": @"last_page",
                                                                  @"products": @"data"
                                                                  }];
}

@end
