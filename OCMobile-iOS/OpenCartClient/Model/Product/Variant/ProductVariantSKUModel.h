//
//  ProductVariantSKUModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/6/4.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductVariantSKUModel;

@interface ProductVariantSKUModel : JSONModel

@property (nonatomic) NSString *key;
@property (nonatomic) NSInteger productId;

@end
