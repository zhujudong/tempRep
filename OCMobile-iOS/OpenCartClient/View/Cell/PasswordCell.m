//
//  PasswordCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 16/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "PasswordCell.h"

static CGFloat const CELL_HEIGHT = 50.0;
static CGFloat const TOGGLE_BUTTON_WIDTH = 50.0;

@interface PasswordCell()
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *togglePasswordButton;
@end

@implementation PasswordCell

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
            _textField.secureTextEntry = YES;
            _textField.keyboardType = UIKeyboardTypeAlphabet;
            _textField.placeholder = NSLocalizedString(@"toast_register_input_password", nil);
            [_textField addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

            [self.contentView addSubview:_textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self.contentView);
                make.leading.equalTo(self.contentView).offset(10);
                make.trailing.equalTo(self.contentView).offset(-TOGGLE_BUTTON_WIDTH);
                make.height.mas_equalTo(CELL_HEIGHT).priorityHigh();
            }];
        }

        if (!_togglePasswordButton) {
            _togglePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_togglePasswordButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
            [_togglePasswordButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
            [_togglePasswordButton addTarget:self action:@selector(togglePasswordButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_togglePasswordButton];
            [_togglePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.top.and.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(TOGGLE_BUTTON_WIDTH);
            }];
        }
    }

    return self;
}

- (void)setText:(NSString *)text {
    _textField.text = text;
}

- (void)togglePasswordButtonClicked {
    [_textField setSecureTextEntry:!_textField.isSecureTextEntry];
    [_togglePasswordButton setSelected:!_togglePasswordButton.isSelected];
}

- (void)textFieldValueChanged:(id)sender {
    if (self.textFieldValueChangedBlock) {
        self.textFieldValueChangedBlock(self.textField.text);
    }
}
@end
