//
//  StripeStoredCardsModel.h
//  afterschoollol
//
//  Created by Sam Chen on 14/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "StripeStoredCardModel.h"

@interface StripeStoredCardsModel : JSONModel
@property (nonatomic) NSArray<StripeStoredCardModel> *cards;
@end
