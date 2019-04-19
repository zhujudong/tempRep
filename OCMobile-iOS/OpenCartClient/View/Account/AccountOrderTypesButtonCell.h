//
//  AccountOrderTypesButtonCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/4/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIOrderTypeButton.h"

#define kCellIdentifier_AccountOrderTypesButtonCell @"AccountOrderTypesButtonCell"

@interface AccountOrderTypesButtonCell : UITableViewCell

@property (strong, nonatomic) UIOrderTypeButton *unpaidControl, *unshippedControl, *shippedControl, *reviewControl, *returnControl;

@end
