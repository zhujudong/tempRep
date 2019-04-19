//
//  TextFieldOnlyCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 21/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_TextFieldOnlyCell @"TextFieldOnlyCell"

@interface TextFieldOnlyCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;

@property (copy, nonatomic) void(^textFieldValueChangedBlock)(NSString *);

- (void)setPlaceholder:(NSString *)text value:(NSString *)value;
- (void)setDisabled;

@end
