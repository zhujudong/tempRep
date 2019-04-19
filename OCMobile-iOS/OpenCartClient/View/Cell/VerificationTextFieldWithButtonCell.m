//
//  VerificationTextFieldWithButtonCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "VerificationTextFieldWithButtonCell.h"

static CGFloat const CELL_HEIGHT = 50.0;
static CGFloat const BUTTON_WIDTH = 100.0;

@implementation VerificationTextFieldWithButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_textField) {
            _textField = [UITextField new];
            _textField.font = [UIFont systemFontOfSize:14];
            [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
            [self.contentView addSubview:_textField];

            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 10, 0, BUTTON_WIDTH + 20));
                make.height.mas_equalTo(CELL_HEIGHT).priorityHigh();
            }];
        }

        if (!_button) {
            _button = [[SendSMSButton alloc] initWithFrame:CGRectZero];
            [_button addTarget:self action:@selector(sendSMSButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_button];

            [_button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(BUTTON_WIDTH);
                make.top.equalTo(self.contentView).offset(5);
                make.bottom.equalTo(self.contentView).offset(-5);
                make.trailing.equalTo(self.contentView).offset(-10);
            }];
        }
    }

    return self;
}

- (void)setPlaceholder:(NSString *)text value:(NSString *)value {
    self.textField.placeholder = text;
    self.textField.text = value;
}

- (void)setDisabled {
    _textField.enabled = NO;
    _textField.textColor = [UIColor grayColor];
}

- (void)textFieldValueChanged:(id)sender {
    if (self.textFieldValueChangedBlock) {
        self.textFieldValueChangedBlock(self.textField.text);
    }
}

- (void)sendSMSButtonClicked:(id)sender{
    if (self.sendSMSButtonClickedBlock) {
        self.sendSMSButtonClickedBlock(sender);
    }
}
@end
