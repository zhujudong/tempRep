//
//  TextViewOnlyCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "TextViewOnlyCell.h"
#import "GCPlaceholderTextView.h"

static CGFloat const TEXT_VIEW_HEIGHT = 100.0;

@interface TextViewOnlyCell()
@property (strong, nonatomic) GCPlaceholderTextView *textView;
@end

@implementation TextViewOnlyCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_textView) {
            __weak typeof(self) weakSelf = self;
            _textView = [GCPlaceholderTextView new];
            _textView.font = [UIFont systemFontOfSize:14];
            _textView.textViewValueChangedBlock = ^(NSString *value) {
                [weakSelf textViewValueChanged:value];
            };

            [self.contentView addSubview:_textView];
            [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(TEXT_VIEW_HEIGHT).priorityHigh();
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            }];
        }
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPlaceholder:(NSString *)text value:(NSString *)value {
    if (value.length > 0) {
        self.textView.text = value;
    }
    self.textView.placeholder = text;
}

- (void)textViewValueChanged:(NSString *)value {
    if (self.textViewValueChangedBlock) {
        if ([value isEqualToString:_textView.placeholder]) {
            return;
        }
        self.textViewValueChangedBlock(value);
    }
}

@end
