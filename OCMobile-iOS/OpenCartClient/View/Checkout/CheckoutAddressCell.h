//
//  CheckoutAddressCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/2/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckoutShippingAddressModel.h"

#define kCellIdentifier_CheckoutAddressCell @"CheckoutAddressCell"

@interface CheckoutAddressCell : UITableViewCell

@property (strong, nonatomic) CheckoutShippingAddressModel *address;

@end
