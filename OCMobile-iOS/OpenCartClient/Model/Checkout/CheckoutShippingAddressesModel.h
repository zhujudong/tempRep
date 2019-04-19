//
//  CheckoutShippingAddressesModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CheckoutShippingAddressModel.h"

@interface CheckoutShippingAddressesModel : JSONModel

@property (nonatomic) NSMutableArray<CheckoutShippingAddressModel> *addresses;

@end
