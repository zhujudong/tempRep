//
//  TextViewOnlyCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_TextViewOnlyCell @"TextViewOnlyCell"

@interface TextViewOnlyCell : UITableViewCell
- (void)setPlaceholder:(NSString *)text value:(NSString *)value;
@property (copy, nonatomic) void(^textViewValueChangedBlock)(NSString *);
@end
