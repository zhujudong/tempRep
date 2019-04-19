//
//  ProductDetailOptionValueModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProductDetailOptionValueModel
@end

@interface ProductDetailOptionValueModel : JSONModel

@property(nonatomic) NSInteger productOptionValueId;
@property(nonatomic) NSString *name;

@end
