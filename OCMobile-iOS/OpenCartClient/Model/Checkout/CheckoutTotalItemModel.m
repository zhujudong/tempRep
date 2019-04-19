//
//  CheckoutTotalItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutTotalItemModel.h"

@implementation CheckoutTotalItemModel

+ (JSONKeyMapper *) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
