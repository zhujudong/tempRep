//
//  AccountAddressCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountAddressItemModel.h"

#define kCellIdentifier_AccountAddressCell @"AccountAddressCell"

@interface AccountAddressCell : UITableViewCell
@property (strong, nonatomic) AccountAddressItemModel *address;

@property (copy, nonatomic) void(^isDefaultButtonClickedBlock)(NSInteger);
@property (copy, nonatomic) void(^editButtonClickedBlock)(AccountAddressItemModel *address);
@property (copy, nonatomic) void(^deleteButtonClickedBlock)(AccountAddressItemModel *address);
@end
