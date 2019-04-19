//
//  AccountOrderInfoProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountOrderInfoProductItemModel
@end

@interface AccountOrderInfoProductItemModel : JSONModel

@property(nonatomic) NSInteger orderProductId;
@property(nonatomic) NSInteger productId;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *image;
@property(nonatomic) NSString<Optional> *option;
@property(nonatomic) NSString *price;
@property(nonatomic) NSInteger quantity;

@end
