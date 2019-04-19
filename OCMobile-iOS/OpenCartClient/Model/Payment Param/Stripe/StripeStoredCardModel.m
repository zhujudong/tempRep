//
//  StripeStoredCardModel.m
//  afterschoollol
//
//  Created by Sam Chen on 17/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "StripeStoredCardModel.h"

@implementation StripeStoredCardModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"cardId": @"stripe_card_id",
                                                                  @"creditCardCode": @"brand_code",
                                                                  @"environment": @"environment",
                                                                  @"expirationMonth": @"exp_month",
                                                                  @"expirationYear": @"exp_year",
                                                                  @"expirationFormat": @"exp_format",
                                                                  @"lastFourDigits": @"last_four",
                                                                  }];
}

- (void)setCreditCardCodeWithNSString:(NSString *)string {
    if ([string isEqualToString:@"visa"]) {
        self.creditCardCode = CreditCardCodeVisa;
    } else if ([string isEqualToString:@"master_card"]) {
        self.creditCardCode = CreditCardCodeMasterCard;
    } else if ([string isEqualToString:@"american_express"]) {
        self.creditCardCode = CreditCardCodeAmericanExpress;
    } else if ([string isEqualToString:@"discover"]) {
        self.creditCardCode = CreditCardCodeDiscover;
    } else if ([string isEqualToString:@"j_c_b"]) {
        self.creditCardCode = CreditCardCodeJCB;
    } else {
        self.creditCardCode = CreditCardCodeUnknown;
    }
}

- (NSString *)creditCardThumbnailName {
    if (self.creditCardCode == CreditCardCodeVisa) {
        return @"card-visa";
    } else if (self.creditCardCode == CreditCardCodeMasterCard) {
        return @"card-mastercard";
    } else if (self.creditCardCode == CreditCardCodeAmericanExpress) {
        return @"card-american-express";
    } else if (self.creditCardCode == CreditCardCodeDiscover) {
        return @"card-discover";
    } else if (self.creditCardCode == CreditCardCodeJCB) {
        return @"card-jcb";
    }

    return @"card-unknown";
}

@end
