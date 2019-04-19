//
//  AccountAddressItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountAddressItemModel
@end

@interface AccountAddressItemModel : JSONModel

@property (nonatomic) NSInteger addressId;
@property (nonatomic) NSString<Optional> *firstname;
@property (nonatomic) NSString<Optional> *lastname;
@property (nonatomic) NSString *fullname;
@property (nonatomic) NSString *telephone;
@property (nonatomic) NSInteger countryId;
@property (nonatomic) NSString *country;
@property (nonatomic) NSInteger zoneId;
@property (nonatomic) NSString *zone;
@property (nonatomic) NSInteger cityId;
@property (nonatomic) NSString *city;
@property (nonatomic) NSInteger countyId;
@property (nonatomic) NSString<Optional> *county;
@property (nonatomic) NSString *postcode;
@property (nonatomic) NSString *address1;
@property (nonatomic) NSString<Optional> *address2;
@property (nonatomic) BOOL isDefault;
@property (nonatomic) NSArray<Optional> *customField;

- (NSString *)stringifyLocation;
- (void)setLocationIdsInOrderedArray:(NSArray *)ids;
- (NSArray *)groupLocationIdsToArray;
- (NSString *)fullnameWithTelephone;
- (NSString *)formattedAddress;
@end
