//
//  CheckoutConfirmResponseModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CheckoutConfirmResponseModel : JSONModel

@property (nonatomic) NSString *paymentMethod;
//@property (nonatomic) NSString *paymentParams;

@end
