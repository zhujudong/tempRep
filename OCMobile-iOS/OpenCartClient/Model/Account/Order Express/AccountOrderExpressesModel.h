//
//  AccountOrderExpressesModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountOrderExpressModel.h"

@interface AccountOrderExpressesModel : JSONModel

@property(nonatomic) NSArray<AccountOrderExpressModel> *expresses;

@end
