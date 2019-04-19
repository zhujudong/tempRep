//
//  ProductDetailSelectedOptionModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductDetailOptionModel.h"

@interface ProductDetailSelectedOptionModel : NSObject

@property (nonatomic) ProductOptionType type;
@property (nonatomic) NSInteger productOptionId;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL required;

- (instancetype)initWithOptionModel: (ProductDetailOptionModel *)option;
- (void)addSelectedOptionValue: (ProductDetailOptionValueModel *)optionValue;
- (void)removeSelectedOptionValue: (ProductDetailOptionValueModel *)optionValue;
- (BOOL)containsValue:(ProductDetailOptionValueModel *)optionValue;
- (NSDictionary *)convertToDict;
- (NSArray *)convertToArray;
- (NSString *)allValueNames;
@end
