//
//  AccountOrderInfoProductCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountOrderInfoProductItemModel.h"

#define kCellIdentifier_AccountOrderInfoProductCell @"AccountOrderInfoProductCell"

@interface AccountOrderInfoProductCell : UITableViewCell
@property (strong, nonatomic) AccountOrderInfoProductItemModel *product;

- (void)setReturnButtonHidden:(BOOL)hidden;
@property (copy, nonatomic) void(^returnButtonClickedBlock)(AccountOrderInfoProductItemModel *);
@end
