//
//  FilterStockStatusModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterStockStatusModel;

@interface FilterStockStatusModel : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger id;

@end
