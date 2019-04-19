//
//  AccountSimpleCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 4/3/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_AccountSimpleCell @"AccountSimpleCell"

@interface AccountSimpleCell : UITableViewCell
- (void)setImage:(NSString *)image title:(NSString *)title;
@end
