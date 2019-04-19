//
//  AccountOrderExpressTraceModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountOrderExpressTraceModel
@end

@interface AccountOrderExpressTraceModel : JSONModel

@property(nonatomic) NSString *time;
@property(nonatomic) NSString *station;

@end
