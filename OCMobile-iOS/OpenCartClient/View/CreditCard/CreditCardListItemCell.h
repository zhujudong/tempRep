//
//  CreditCardListItemCell.h
//  afterschoollol
//
//  Created by Sam Chen on 10/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StripeStoredCardsModel.h"

#define kCellIdentifier_CreditCardListItemCell @"CreditCardListItemCell"

@interface CreditCardListItemCell : UITableViewCell
@property (strong, nonatomic) StripeStoredCardModel *card;
@end
