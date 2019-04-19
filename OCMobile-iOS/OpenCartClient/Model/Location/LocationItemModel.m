//
//  LocationItemModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/11.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "LocationItemModel.h"

@implementation LocationItemModel

+ (JSONKeyMapper *)keyMapper {
    return [JSONKeyMapper mapperForSnakeCase];
}

- (NSInteger)convertItemIdToRowIndex:(NSInteger)itemId {
    if (_items.count < 1) {
        return 0;
    }

    NSInteger i = 0;
    for (LocationItemModel *item in _items) {
        if (item.id == itemId) {
            return i;
        }
        i++;
    }
    return i;
}
@end
