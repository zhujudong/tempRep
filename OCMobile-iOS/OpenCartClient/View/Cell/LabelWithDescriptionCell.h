//
//  LabelWithDescriptionCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_LabelWithDescriptionCell @"LabelWithDescriptionCell"

@interface LabelWithDescriptionCell : UITableViewCell

@property (strong, nonatomic) UILabel *label, *descriptionLabel;

- (void)setPlaceholder:(NSString *)text description:(NSString *)descriptionText;

@end
