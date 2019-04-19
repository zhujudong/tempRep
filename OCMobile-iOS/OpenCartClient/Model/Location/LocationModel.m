//
//  LocationModel.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"items": @"countries"
                                                                  }];
}

- (NSArray *)mapLocationIdsToRows:(AccountAddressItemModel *)address {
    NSMutableArray *rows = [[NSMutableArray alloc] init];

    // country
    NSInteger row = 0;
    NSArray<LocationItemModel> *items = [_items copy];
    if (address.countryId > 0) {
        for (NSInteger i = 0; i < items.count; i++) {
            LocationItemModel *item = [items objectAtIndex:i];
            if (item.id == address.countryId) {
                row = i;
                items = item.items;
                break;
            }
        }
    }
    [rows addObject:[NSNumber numberWithInteger:row]];

    // zone
    row = 0;
    if (address.zoneId && items) {
        for (NSInteger i = 0; i < items.count; i++) {
            LocationItemModel *item = [items objectAtIndex:i];
            if (item.id == address.zoneId) {
                row = i;
                items = item.items;
                break;
            }
        }
    }
    [rows addObject:[NSNumber numberWithInteger:row]];

    // city
    row = 0;
    if (address.cityId && items) {
        for (NSInteger i = 0; i < items.count; i++) {
            LocationItemModel *item = [items objectAtIndex:i];
            if (item.id == address.cityId) {
                row = i;
                items = item.items;
                break;
            }
        }
    }
    [rows addObject:[NSNumber numberWithInteger:row]];

    // county
    row = 0;
    if (address.countyId && items) {
        for (NSInteger i = 0; i < items.count; i++) {
            LocationItemModel *item = [items objectAtIndex:i];
            if (item.id == address.countyId) {
                row = i;
                break;
            }
        }
    }
    [rows addObject:[NSNumber numberWithInteger:row]];

    return rows;
}
@end
