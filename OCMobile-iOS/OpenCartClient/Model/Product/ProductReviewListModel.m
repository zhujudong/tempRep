//
//  ProductReviewListModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/25/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewListModel.h"

@implementation ProductReviewListModel

+ (JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"currentPage": @"current_page",
                                                                  @"lastPage": @"last_page",
                                                                  @"reviews": @"data"}];
}

@end
