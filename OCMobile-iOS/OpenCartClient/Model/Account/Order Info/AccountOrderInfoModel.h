//
//  AccountOrderInfoModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountOrderInfoProductItemModel.h"
#import "AccountOrderInfoTotalItemModel.h"
#import "AccountOrderInfoHistoryItemModel.h"

@interface AccountOrderInfoModel : JSONModel

@property(nonatomic) NSString *orderId;
@property(nonatomic) NSString *orderStatusCode;
//@property(nonatomic) NSString *shippingFirstname;
//@property(nonatomic) NSString<Optional> *shippingLastname;
@property(nonatomic) NSString *shippingFullname;
@property(nonatomic) NSString *shippingTelephone;
@property(nonatomic) NSString *shippingAddress1;
@property(nonatomic) NSString<Optional> *shippingAddress2;
@property(nonatomic) NSString *shippingCountry;
@property(nonatomic) NSString *shippingZone;
@property(nonatomic) NSString<Optional> *shippingCity;
@property(nonatomic) NSString<Optional> *shippingCounty;
@property(nonatomic) NSArray *shippingCustomField;
@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSString *paymentMethod;
@property(nonatomic) NSString *paymentCode;
@property(nonatomic) NSString *shippingMethod;
@property(nonatomic) NSString *totalFormat;
@property(nonatomic) NSMutableArray<AccountOrderInfoProductItemModel> *products;
@property(nonatomic) NSMutableArray<AccountOrderInfoTotalItemModel> *totals;
@property(nonatomic) NSMutableArray<AccountOrderInfoHistoryItemModel> *histories;

- (NSString *)fullnameWithTelephone;
- (NSString *)formattedAddress;
@end
