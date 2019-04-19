//
//  OpenSelectionModalCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 23/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_OpenSelectionModalCell @"OpenSelectionModalCell"

@interface OpenSelectionModalCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) NSInteger selectedOptionKey;
@property (strong, nonatomic) NSArray *options;

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UILabel *selectedText;
@property (strong, nonatomic) UIView *reasonPickerMaskView;
@property (strong, nonatomic) UIPickerView *reasonPickerView;
@property (copy, nonatomic) NSArray* (^getOptionsBlock)(void);
- (void)setLabel:(NSString *)text options:(BOOL)on;
@end
