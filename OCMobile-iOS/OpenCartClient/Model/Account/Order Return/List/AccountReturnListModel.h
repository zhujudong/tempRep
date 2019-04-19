//
//  AccountReturnListModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountReturnListItemModel.h"

@interface AccountReturnListModel : JSONModel

@property(nonatomic) NSArray<AccountReturnListItemModel> *orderReturns;

@end
