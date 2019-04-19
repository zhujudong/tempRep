//
//  VerificationTextFieldWithButtonCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSMSButton.h"

#define kCellIdentifier_VerificationTextFieldWithButtonCell @"VerificationTextFieldWithButtonCell"

@interface VerificationTextFieldWithButtonCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) SendSMSButton *button;

@property (copy, nonatomic) void(^textFieldValueChangedBlock)(NSString *);
@property (copy, nonatomic) void(^sendSMSButtonClickedBlock)(SendSMSButton *);

- (void)setPlaceholder:(NSString *)text value:(NSString *)value;
- (void)setDisabled;
@end
