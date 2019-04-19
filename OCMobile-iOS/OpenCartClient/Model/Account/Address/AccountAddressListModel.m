//
//  AccountAddressListModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAddressListModel.h"

@implementation AccountAddressListModel

+(JSONKeyMapper*) keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

@end
