//
//  CheckoutShippingAddressModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CheckoutShippingAddressModel
@end

@interface CheckoutShippingAddressModel : JSONModel

@property(nonatomic) NSInteger addressId;
//@property(nonatomic) NSString *firstname;
//@property(nonatomic) NSString<Optional> *lastname;
@property(nonatomic) NSString *fullname;
@property(nonatomic) NSString *telephone;
//@property(nonatomic) NSInteger countryId;
@property(nonatomic) NSString *country;
//@property(nonatomic) NSInteger zoneId;
@property(nonatomic) NSString *zone;
@property(nonatomic) NSString<Optional> *city;
@property(nonatomic) NSString<Optional> *county;
@property(nonatomic) NSString *postcode;
@property(nonatomic) NSString *address1;
@property(nonatomic) NSString<Optional> *address2;
@property(nonatomic) BOOL isDefault;
@property(nonatomic) NSArray<Optional> *customField;

- (NSString *)fullnameWithTelephone:(BOOL)telephone;
- (NSString *)formattedAddress;
@end
