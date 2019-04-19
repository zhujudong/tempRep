//
//  VariantModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "VariantValueModel.h"

@protocol VariantModel;

@interface VariantModel : JSONModel

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSString *name;
@property (nonatomic) NSArray<VariantValueModel> *values;

- (VariantValueModel *)valueAtIndex:(NSInteger)index;

@end
