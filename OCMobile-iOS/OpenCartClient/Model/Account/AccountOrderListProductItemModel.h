//
//  AccountOrderListProductItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountOrderListProductItemModel
@end

@interface AccountOrderListProductItemModel : JSONModel

@property(nonatomic) NSString* name;
@property(nonatomic) NSString* image;

@end
