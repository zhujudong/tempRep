//
//  FilterVariantValueModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 06/06/2018.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "JSONModel.h"

@protocol FilterVariantValueModel;

@interface FilterVariantValueModel : JSONModel

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *name;

@end
