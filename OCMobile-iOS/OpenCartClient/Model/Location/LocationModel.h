//
//  LocationModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "LocationItemModel.h"
#import "AccountAddressItemModel.h"

@interface LocationModel : JSONModel
@property(nonatomic) NSArray<LocationItemModel, Optional> *items;

- (NSArray *)mapLocationIdsToRows:(AccountAddressItemModel *)address;
@end
