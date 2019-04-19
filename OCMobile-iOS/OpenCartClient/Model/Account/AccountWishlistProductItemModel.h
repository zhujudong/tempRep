//
//  AccountWishlistProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountWishlistProductItemModel
@end

@interface AccountWishlistProductItemModel : JSONModel

@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString *priceFormat;
@property(nonatomic) NSString<Optional> *special;

@end
