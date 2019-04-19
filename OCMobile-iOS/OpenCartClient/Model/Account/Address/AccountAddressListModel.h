//
//  AccountAddressListModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountAddressItemModel.h"

@interface AccountAddressListModel : JSONModel

@property(nonatomic) NSArray<AccountAddressItemModel> *addresses;

@end
