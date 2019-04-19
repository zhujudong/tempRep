//
//  ReturnReasonSelectorCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ReturnReasonSelectorCell.h"
#import "ReturnReasonsModel.h"
#import "ReturnReasonModel.h"

@interface ReturnReasonSelectorCell()
@property(strong, nonatomic) ReturnReasonsModel *reasonsModel;
@property(nonatomic) NSInteger selectedRowIndex;
@end

@implementation ReturnReasonSelectorCell

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
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_selectedLabel) {
            _selectedLabel = [UILabel new];
            _selectedLabel.font = [UIFont systemFontOfSize:12];
            _selectedLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
            _selectedLabel.text = NSLocalizedString(@"label_please_select", nil);
            [self.contentView addSubview:_selectedLabel];
            [_selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }

        if (!_reasonsModel) {
            [self loadData];
        }
    }

    return self;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"settings/return_reasons" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            weakSelf.reasonsModel = [[ReturnReasonsModel alloc] initWithDictionary:data error:nil];
            if (weakSelf.reasonsModel.reasons.count) {
                weakSelf.selectedRowIndex = 0;
                ReturnReasonModel *reason = [weakSelf.reasonsModel.reasons objectAtIndex:weakSelf.selectedRowIndex];
                [weakSelf updateSelectedLabel:reason.name];
                [weakSelf selectedValueChanged:reason];
            }
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        [self showPickerView];
    }
}

- (void)showPickerView {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;

    if (!_reasonsModel) {
        [MBProgressHUD showToastToView:window withMessage:NSLocalizedString(@"toast_get_return_reason_failed", nil)];

        return;
    }

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

    [_reasonPickerView selectRow:_selectedRowIndex inComponent:0 animated:NO];

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
    return _reasonsModel.reasons.count;
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

    ReturnReasonModel *reason = [_reasonsModel.reasons objectAtIndex:row];
    label.text = reason.name;

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedRowIndex = row;
    ReturnReasonModel *reason = [_reasonsModel.reasons objectAtIndex:_selectedRowIndex];
    [self updateSelectedLabel:reason.name];
    [self selectedValueChanged:reason];
}

- (void)updateSelectedLabel:(NSString *)text {
    _selectedLabel.text = text;
}

- (void)selectedValueChanged:(ReturnReasonModel *)reason {
    if (self.selectedValueChangedBlock) {
        self.selectedValueChangedBlock(reason.returnReasonId);
    }
}
@end
