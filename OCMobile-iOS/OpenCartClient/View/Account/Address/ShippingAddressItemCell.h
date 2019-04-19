//
//  ShippingAddressItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountAddressItemModel.h"

#define kCellIdentifier_ShippingAddressItemCell @"ShippingAddressItemCell"

@interface ShippingAddressItemCell : UITableViewCell
@property (strong, nonatomic) AccountAddressItemModel *address;

@property (copy, nonatomic) void(^editButtonClickedBlock)(AccountAddressItemModel *);

- (void)setCheckImageHighlighted:(BOOL)highlighted;

@end
