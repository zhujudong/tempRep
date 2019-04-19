//
//  OpenSelectionModalCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 23/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "OpenSelectionModalCell.h"

@interface OpenSelectionModalCell()
@property (assign, nonatomic) NSInteger selectedRowNumber;
@end

@implementation OpenSelectionModalCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_label) {
            _label = [UILabel new];
            _label.font = [UIFont systemFontOfSize:14];
            _label.text = NSLocalizedString(@"label_please_select", nil);
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }
        if (!_selectedText) {
            _selectedText = [UILabel new];
            _selectedText.font = [UIFont systemFontOfSize:14];
            _selectedText.text = NSLocalizedString(@"label_please_select", nil);
            [self.contentView addSubview:_selectedText];
            [_selectedText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (_getOptionsBlock) {
            //NSArray *options = _getOptionsBlock();
        }
    }

    return self;
}

- (void)setLabel:(NSString *)text options:(BOOL)on {
    self.label.text = text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self showPickerView];
    }
}

- (void)showPickerView {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    //mask view
    _reasonPickerMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _reasonPickerMaskView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:1.];
    _reasonPickerMaskView.alpha = 0.0;

    UITapGestureRecognizer *closeMaskViewGesture = [[UITapGestureRecognizer alloc] init];
    [closeMaskViewGesture addTarget:self action:@selector(dismissPickerView)];
    [_reasonPickerMaskView addGestureRecognizer:closeMaskViewGesture];

    [window addSubview:_reasonPickerMaskView];

    //picker view
    CGFloat X = 0;
    CGFloat Y = self.window.frame.size.height;
    //  CGFloat Y = self.view.frame.size.height * .7;
    _reasonPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(X, Y, SCREEN_WIDTH, SCREEN_HEIGHT * .3)];
    _reasonPickerView.backgroundColor = [UIColor whiteColor];
    _reasonPickerView.delegate = self;
    _reasonPickerView.dataSource = self;

    [window addSubview:_reasonPickerView];

    [_reasonPickerView selectRow:_selectedRowNumber inComponent:0 animated:NO];

    //Animate in
    [UIView animateWithDuration:.2 delay:.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _reasonPickerMaskView.alpha = .6;

        CGRect frame = _reasonPickerView.frame;
        frame.origin.y = SCREEN_HEIGHT * .7;
        _reasonPickerView.frame = frame;
    } completion:^(BOOL finished) {

    }];
}

- (void)dismissPickerView {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        //更新选择器的 Y
        CGRect frame = _reasonPickerView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        _reasonPickerView.frame = frame;

        _reasonPickerMaskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_reasonPickerMaskView removeFromSuperview];
        [_reasonPickerView removeFromSuperview];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _options.count;
}

//delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 36.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return SCREEN_WIDTH * .8;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (id)view;

    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.];
    }

    NSDictionary *option = [_options objectAtIndex:row];

    _label.text = [option objectForKey:@"value"];

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRowNumber = row;

    NSDictionary *option = [_options objectAtIndex:row];

    _selectedOptionKey = [[option objectForKey:@"key"] integerValue];

    _label.text = [option objectForKey:@"value"];
}
@end
