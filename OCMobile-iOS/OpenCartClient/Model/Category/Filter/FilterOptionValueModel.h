//
//  FilterOptionValueModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterOptionValueModel;

@interface FilterOptionValueModel : JSONModel

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;

@end
