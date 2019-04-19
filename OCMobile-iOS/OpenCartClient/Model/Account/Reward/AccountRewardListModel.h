//
//  AccountRewardListModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountRewardHistoryModel.h"

@interface AccountRewardListModel : JSONModel

@property(nonatomic) NSInteger rewardTotal;
@property(nonatomic) NSArray<AccountRewardHistoryModel> *rewards;

@end
