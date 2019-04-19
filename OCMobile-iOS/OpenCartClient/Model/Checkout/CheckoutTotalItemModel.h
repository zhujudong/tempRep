//
//  CheckoutTotalItemModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CheckoutTotalItemModel
@end

@interface CheckoutTotalItemModel : JSONModel

@property(nonatomic) NSString *title;
@property(nonatomic) NSString *valueFormat;

@end
