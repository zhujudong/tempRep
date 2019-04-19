//
//  AccountOrderInfoTotalItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountOrderInfoTotalItemModel
@end

@interface AccountOrderInfoTotalItemModel : JSONModel

@property(nonatomic) NSString *title;
@property(nonatomic) NSString *valueFormat;

@end
