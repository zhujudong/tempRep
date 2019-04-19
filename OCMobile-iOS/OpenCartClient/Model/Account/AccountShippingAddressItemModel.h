//
//  AccountShippingAddressItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountShippingAddressItemModel
@end

@interface AccountShippingAddressItemModel : JSONModel

@property (nonatomic) NSInteger addressId;
@property (nonatomic) NSInteger isDefault;
@property (nonatomic) NSString* firstname;
//@property (nonatomic) NSString* telephone;
@property (nonatomic) NSString* formattedAddress;

@end
