//
//  QuantitySelectorCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 23/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIQuantityControl.h"

#define kCellIdentifier_QuantitySelectorCell @"QuantitySelectorCell"

@interface QuantitySelectorCell : UITableViewCell <UIQuantityControlDelegate>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIQuantityControl *quantityControl;

@property (copy, nonatomic) void(^quantityValueChangedBlock)(NSInteger);

- (void)setPlaceholder:(NSString *)text value:(NSInteger)value;
@end
