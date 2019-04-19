//
//  StripeStoredCardModel.h
//  afterschoollol
//
//  Created by Sam Chen on 17/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, CreditCardCode) {
  CreditCardCodeUnknown,
  CreditCardCodeVisa,
  CreditCardCodeMasterCard,
  CreditCardCodeAmericanExpress,
  CreditCardCodeDiscover,
  CreditCardCodeJCB
};

@protocol StripeStoredCardModel;

@interface StripeStoredCardModel : JSONModel
@property (nonatomic) NSString *cardId;
@property (nonatomic) CreditCardCode creditCardCode;
@property (nonatomic) NSString *expirationYear;
@property (nonatomic) NSString *expirationMonth;
@property (nonatomic) NSString *expirationFormat;
@property (nonatomic) NSString *lastFourDigits;
@property (nonatomic) NSString *environment;

- (NSString *)creditCardThumbnailName;
@end
