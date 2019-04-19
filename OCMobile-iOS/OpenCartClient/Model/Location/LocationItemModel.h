//
//  LocationItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/11.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"

@protocol LocationItemModel;
@interface LocationItemModel : JSONModel

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<LocationItemModel, Optional> *items;

@end
