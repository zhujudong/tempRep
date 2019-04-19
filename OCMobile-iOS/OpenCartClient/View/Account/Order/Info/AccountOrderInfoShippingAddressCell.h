//
//  AccountOrderInfoShippingAddressCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderInfoModel.h"

#define kCellIdentifier_AccountOrderInfoShippingAddressCell @"AccountOrderInfoShippingAddressCell"

@interface AccountOrderInfoShippingAddressCell : UITableViewCell
@property (strong, nonatomic) AccountOrderInfoModel *order;

@end
