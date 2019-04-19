//
//  CheckoutShippingMethodCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutShippingMethodModel.h"

#define kCellIdentifier_CheckoutShippingMethodCell @"CheckoutShippingMethodCell"

@interface CheckoutShippingMethodCell : UITableViewCell

@property(strong, nonatomic) CheckoutShippingMethodModel *shippingMethod;

- (void)setCheckImageHighlighted:(BOOL)highlighted;
@end
