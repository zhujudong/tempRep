//
//  LocationSelectorCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountAddressItemModel.h"

#define kCellIdentifier_LocationSelectorCell @"LocationSelectorCell"

@interface LocationSelectorCell : UITableViewCell
@property (strong, nonatomic) AccountAddressItemModel *address;
@property (copy, nonatomic) void(^locationSelectorCellClickedBlock)(void);
@property (copy, nonatomic) void(^locationValueChangedBlock)(AccountAddressItemModel *address);
@property (weak, nonatomic) UIViewController *viewController;
@end
