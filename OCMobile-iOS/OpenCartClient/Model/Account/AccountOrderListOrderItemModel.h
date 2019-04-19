//
//  AccountOrderListOrderItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountOrderListProductItemModel.h"

@protocol AccountOrderListOrderItemModel
@end

@interface AccountOrderListOrderItemModel : JSONModel

@property(nonatomic) NSString *orderId;
@property(nonatomic) NSInteger orderStatusId;
@property(nonatomic) NSString *orderStatusName;
@property(nonatomic) NSString *orderStatusCode;
@property(nonatomic) NSString *totalFormat;
@property(nonatomic) BOOL hasTracks;
@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSMutableArray<AccountOrderListProductItemModel> *products;

@end
