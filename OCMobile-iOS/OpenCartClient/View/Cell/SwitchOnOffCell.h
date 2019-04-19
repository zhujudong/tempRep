//
//  SwitchOnOffCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_SwitchOnOffCell @"SwitchOnOffCell"

@interface SwitchOnOffCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UISwitch *switchButton;

@property (copy, nonatomic) void(^swithValueChangedBlock)(BOOL);

- (void)setLabel:(NSString *)text on:(BOOL)on;
- (void)setDisabled;

@end
