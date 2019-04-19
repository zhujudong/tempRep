//
//  CheckoutPaymentMethodCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutPaymentMethodModel.h"

#define kCellIdentifier_CheckoutPaymentMethodCell @"CheckoutPaymentMethodCell"

@interface CheckoutPaymentMethodCell : UITableViewCell
@property(strong, nonatomic) CheckoutPaymentMethodModel *paymentMethod;

- (void)setCheckImageHighlighted:(BOOL)highlighted;
@end
