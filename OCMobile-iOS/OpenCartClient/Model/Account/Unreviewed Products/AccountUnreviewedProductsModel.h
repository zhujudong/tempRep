//
//  AccountUnreviewedProductsModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountUnreviewedProductModel.h"

@interface AccountUnreviewedProductsModel : JSONModel

@property(nonatomic) NSArray<AccountUnreviewedProductModel> *products;

@end
