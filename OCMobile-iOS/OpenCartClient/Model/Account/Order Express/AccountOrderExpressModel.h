//
//  AccountOrderExperssModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AccountOrderExpressTraceModel.h"

@protocol AccountOrderExpressModel
@end

@interface AccountOrderExpressModel : JSONModel

@property(nonatomic)NSString *code;
@property(nonatomic)NSString *name;
@property(nonatomic)NSString *expressNo;
@property(nonatomic)NSArray<AccountOrderExpressTraceModel> *traces;

@end
