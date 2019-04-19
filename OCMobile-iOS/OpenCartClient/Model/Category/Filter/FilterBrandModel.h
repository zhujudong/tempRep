//
//  FilterBrandModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterBrandModel;

@interface FilterBrandModel : JSONModel

@property (nonatomic) NSString *name, *image;
@property (nonatomic) NSInteger id;

@end
