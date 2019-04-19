//
//  ReturnReasonModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/7/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ReturnReasonModel
@end

@interface ReturnReasonModel : JSONModel

@property(nonatomic) NSInteger returnReasonId;
@property(nonatomic) NSString *name;

@end
