//
//  AccountReturnInfoModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountReturnInfoHistoryModel.h"

@interface AccountReturnInfoModel : JSONModel

@property(nonatomic) NSInteger returnId;
@property(nonatomic) NSString *orderId;
@property(nonatomic) NSString *product;
@property(nonatomic) NSString *firstname;
@property(nonatomic) NSString *telephone;
@property(nonatomic) NSString *dateOrdered;
@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSString *statusName;
@property(nonatomic) NSString *reasonName;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSArray<AccountReturnInfoHistoryModel> *histories;

@end
