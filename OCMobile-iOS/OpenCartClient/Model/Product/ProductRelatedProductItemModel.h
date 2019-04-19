//
//  ProductRelatedProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 04/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductRelatedProductItemModel
@end

@interface ProductRelatedProductItemModel : JSONModel

@property (nonatomic) NSInteger productId;
@property (nonatomic) NSString *image;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber<Optional> *special;
@property (nonatomic) NSString *priceFormat;
@property (nonatomic) NSString *specialFormat;

@end
