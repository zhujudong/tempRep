//
//  AccountOrderInfoHistoryItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountOrderInfoHistoryItemModel
@end

@interface AccountOrderInfoHistoryItemModel : JSONModel

@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSString<Optional> *statusName;
@property(nonatomic) NSString<Optional> *comment;

@end
