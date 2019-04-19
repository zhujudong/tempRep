//
//  TextFieldOnlyCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 21/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "TextFieldOnlyCell.h"

static CGFloat const TEXT_FIELD_HEIGHT = 50.0;

@implementation TextFieldOnlyCell

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
                make.top.bottom.equalTo(self.contentView);
                make.leading.equalTo(self.contentView).offset(10);
                make.height.mas_equalTo(TEXT_FIELD_HEIGHT).priorityHigh();
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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

@end
