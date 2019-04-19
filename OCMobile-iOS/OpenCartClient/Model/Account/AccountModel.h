//
//  AccountModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/21/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AccountModel : JSONModel

@property (nonatomic) NSInteger customerId;
@property (nonatomic) NSString<Optional> *firstname;
@property (nonatomic) NSString<Optional> *lastname;
@property (nonatomic) NSString<Optional> *fullname;
@property (nonatomic) NSString<Optional> *email;
@property (nonatomic) NSString<Optional> *telephone;
@property (nonatomic) NSString<Optional> *avatar;
@property (nonatomic) NSInteger cartNumber;
@property (nonatomic) NSString<Optional> *accessToken;
@property (nonatomic) NSInteger unpaidOrders;
@property (nonatomic) NSInteger paidOrders;
@property (nonatomic) NSInteger shippedOrders;
@property (nonatomic) NSInteger unreviewedOrderProducts;

- (NSString *)fullname;

@end
