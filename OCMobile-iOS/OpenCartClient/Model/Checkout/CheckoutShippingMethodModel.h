//
//  CheckoutShippingMethodModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CheckoutShippingMethodModel
@end

@interface CheckoutShippingMethodModel : JSONModel

@property(nonatomic) NSString *code;
@property(nonatomic) NSString *title;
@property(nonatomic) NSString *costFormat;

@end
