//
//  StripeNewCardModel.h
//  afterschoollol
//
//  Created by Sam Chen on 14/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StripeNewCardModel : JSONModel
@property (nonatomic) NSString *cardNumber;
@property (nonatomic) NSString *expirationMonth;
@property (nonatomic) NSString *expirationYear;
@property (nonatomic) NSString *cvc;
@property (nonatomic) BOOL saveCard;
@end
