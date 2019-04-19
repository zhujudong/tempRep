//
//  AccountReturnListItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/8/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AccountReturnListItemModel
@end

@interface AccountReturnListItemModel : JSONModel

@property(nonatomic) NSInteger returnId;
@property(nonatomic) NSString *product;
@property(nonatomic) NSString *statusName;
@property(nonatomic) NSString *dateAdded;

@end
