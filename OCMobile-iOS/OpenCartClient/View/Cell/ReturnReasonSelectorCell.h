//
//  ReturnReasonSelectorCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_ReturnReasonSelectorCell @"ReturnReasonSelectorCell"

@interface ReturnReasonSelectorCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *selectedLabel;
@property (strong, nonatomic) UIView *reasonPickerMaskView;
@property (strong, nonatomic) UIPickerView *reasonPickerView;

@property (copy, nonatomic) void(^selectedValueChangedBlock)(NSInteger returnReasonId);

@end
