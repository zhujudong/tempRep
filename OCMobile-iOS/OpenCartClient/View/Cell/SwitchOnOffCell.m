//
//  SwitchOnOffCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SwitchOnOffCell.h"

static CGFloat const CELL_HEIGHT=  50.0;

@implementation SwitchOnOffCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_label) {
            _label = [UILabel new];
            _label.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(10);
                make.top.and.bottom.equalTo(self.contentView);
                make.height.mas_equalTo(CELL_HEIGHT).priorityHigh();
            }];
        }

        if (!_switchButton) {
            _switchButton = [UISwitch new];
            [_switchButton addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];

            [self.contentView addSubview:_switchButton];
            [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setLabel:(NSString *)text on:(BOOL)on {
    self.label.text = text;
    [self.switchButton setOn:on];
}

- (void)setDisabled {
    _switchButton.enabled = YES;
}

- (void)switchValueChanged {
    if (self.swithValueChangedBlock) {
        self.swithValueChangedBlock(self.switchButton.isOn);
    }
}

@end
