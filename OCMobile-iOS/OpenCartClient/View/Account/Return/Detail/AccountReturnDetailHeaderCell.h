//
//  AccountReturnDetailHeaderCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_AccountReturnDetailHeaderCell @"AccountReturnDetailHeaderCell"

@interface AccountReturnDetailHeaderCell : UITableViewCell

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
