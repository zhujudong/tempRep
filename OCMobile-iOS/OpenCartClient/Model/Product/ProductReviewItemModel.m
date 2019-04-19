//
//  ProductReviewItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/15/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewItemModel.h"

@implementation ProductReviewItemModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
