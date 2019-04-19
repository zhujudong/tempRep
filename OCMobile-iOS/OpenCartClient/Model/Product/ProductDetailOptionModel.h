//
//  ProductDetailOptionModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "ProductDetailOptionValueModel.h"

typedef NS_ENUM(NSUInteger, ProductOptionType) {
    ProductOptionTypeRadio,
    ProductOptionTypeCheckbox
};

@protocol ProductDetailOptionModel
@end

@interface ProductDetailOptionModel : JSONModel

@property(nonatomic) NSInteger productOptionId;
@property(nonatomic) NSString *name;
@property(nonatomic) ProductOptionType type;
@property(nonatomic) BOOL required;
@property(nonatomic) NSArray<ProductDetailOptionValueModel> *productOptionValue;

@end
