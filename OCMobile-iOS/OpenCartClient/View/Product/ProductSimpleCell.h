//
//  ProductSimpleCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 3/14/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_ProductSimpleCell @"ProductSimpleCell"

@interface ProductSimpleCell : UITableViewCell

@property (strong, nonatomic) UILabel *keyLabel, *valueLabel;

- (void)setTextForKey:(NSString *)key withValue:(NSString *)value;

@end
