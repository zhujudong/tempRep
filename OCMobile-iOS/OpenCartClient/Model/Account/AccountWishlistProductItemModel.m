//
//  AccountWishlistProductItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountWishlistProductItemModel.h"

@implementation AccountWishlistProductItemModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
