//
//  ProductDetailImageItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductDetailImageItemModel
@end

@interface ProductDetailImageItemModel : JSONModel

@property (nonatomic) NSString *image;

@end
