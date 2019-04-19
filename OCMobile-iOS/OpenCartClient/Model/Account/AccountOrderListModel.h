//
//  AccountOrderListModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountOrderListOrderItemModel.h"

@interface AccountOrderListModel : JSONModel

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastPage;
@property(nonatomic) NSMutableArray<AccountOrderListOrderItemModel> *orders;

@end
