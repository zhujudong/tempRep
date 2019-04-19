//
//  CheckoutPaymentWeChatModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CheckoutPaymentWeChatModel : JSONModel

@property(nonatomic) NSString *appId;
@property(nonatomic) NSString *partnerId;
@property(nonatomic) NSString *prepayId;
@property(nonatomic) NSString *package;
@property(nonatomic) NSString *nonceStr;
@property(nonatomic) UInt32 timestamp;
@property(nonatomic) NSString *sign;

@end
