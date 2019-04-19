//
//  CheckoutConfirmResponseModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CheckoutConfirmResponseModel.h"

@implementation CheckoutConfirmResponseModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
