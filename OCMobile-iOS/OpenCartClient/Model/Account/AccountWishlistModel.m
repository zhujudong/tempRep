//
//  AccountWishlistModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountWishlistModel.h"

@implementation AccountWishlistModel

+(JSONKeyMapper*) keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"products": @"wishlist"}];
}

@end
