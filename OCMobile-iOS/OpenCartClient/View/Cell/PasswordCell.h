//
//  PasswordCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 16/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_PasswordCell @"PasswordCell"

@interface PasswordCell : UITableViewCell
@property (strong, nonatomic) NSString *text;
@property (copy, nonatomic) void(^textFieldValueChangedBlock)(NSString *);
@end
