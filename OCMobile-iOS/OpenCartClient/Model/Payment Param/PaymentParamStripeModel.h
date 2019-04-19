//
//  PaymentParamStripeModel.h
//  afterschoollol
//
//  Created by Sam Chen on 14/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PaymentParamStripeModel : JSONModel
@property (nonatomic) NSString *currency;
@property (nonatomic) BOOL saveCards;
@property (nonatomic) NSString *subject;
@property (nonatomic) CGFloat total;
@end
