//
//  AccountWishlistModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountWishlistProductItemModel.h"

@interface AccountWishlistModel : JSONModel

@property(nonatomic) NSMutableArray<AccountWishlistProductItemModel> *products;

@end
