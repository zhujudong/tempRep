//
//  AccountReturnInfoHistoryModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountReturnInfoHistoryModel
@end

@interface AccountReturnInfoHistoryModel : JSONModel

@property(nonatomic) NSString *dateAdded;
@property(nonatomic) NSString *comment;
@property(nonatomic) NSString *statusName;

@end
