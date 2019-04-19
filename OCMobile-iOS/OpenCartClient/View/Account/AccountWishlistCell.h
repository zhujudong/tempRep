//
//  AccountWishlistCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountWishlistProductItemModel.h"

#define kCellIdentifier_AccountWishlistCell @"AccountWishlistCell"

@interface AccountWishlistCell : UITableViewCell
@property (strong, nonatomic) AccountWishlistProductItemModel *product;
@end
