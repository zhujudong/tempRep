//
//  MobileInputCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 19/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "MobileInputCell.h"
#import "NBPhoneNumberUtil.h"

static CGFloat const CELL_HEIGHT = 50.0;
static CGFloat const COUNTRY_BUTTON_WIDTH = 100.0;

@interface MobileInputCell()
@property (strong, nonatomic) NSDictionary *regionsWithNumber;
@property (strong, nonatomic) UIButton *regionButton;
@property (strong, nonatomic) UIView *sepLine;
@property (strong, nonatomic) UITextField *mobileTextField;
@end

@implementation MobileInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (CONFIG_MOBILE_INTERNATIONAL && !_regionButton) {
            _regionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _regionButton.titleLabel.font = [UIFont systemFontOfSize:14];
            _regionButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [_regionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_regionButton addTarget:self action:@selector(regionButtonClicked) forControlEvents:UIControlEventTouchUpInside];

            [self.contentView addSubview:_regionButton];
            [_regionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.and.bottom.equalTo(self.contentView);
                make.size.mas_equalTo(CGSizeMake(COUNTRY_BUTTON_WIDTH, CELL_HEIGHT)).priorityHigh();
            }];
        }

        if (CONFIG_MOBILE_INTERNATIONAL && !_sepLine) {
            _sepLine = [UIView new];
            _sepLine.backgroundColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;

            [self.contentView addSubview:_sepLine];
            [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self.contentView);
                make.width.mas_equalTo(0.5);
                make.leading.equalTo(_regionButton.mas_trailing);
            }];
        }

        if (!_mobileTextField) {
            _mobileTextField = [UITextField new];
            _mobileTextField.font = [UIFont systemFontOfSize:14];
            _mobileTextField.keyboardType = UIKeyboardTypePhonePad;
            _mobileTextField.placeholder = NSLocalizedString(@"label_account_register_input_telephone", nil);
            [_mobileTextField addTarget:self action:@selector(mobileNumberValueChanged) forControlEvents:UIControlEventEditingChanged];

            [self.contentView addSubview:_mobileTextField];
            [_mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                if (CONFIG_MOBILE_INTERNATIONAL) {
                    make.leading.equalTo(_sepLine.mas_trailing).offset(10);
                } else {
                    make.leading.equalTo(self.contentView).offset(10);
                    make.height.mas_equalTo(CELL_HEIGHT).priorityHigh();
                }

                make.top.bottom.and.trailing.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (void)setRegionCode:(NSString *)regionCode {
    _regionCode = regionCode;

    for (CallingCodeModel *callingCode in _callingCodes) {
        if (callingCode.code == regionCode) {
            [_regionButton setTitle:[NSString stringWithFormat:@"%@ +%@",callingCode.name, callingCode.code] forState:UIControlStateNormal];
        }
    }
}

- (void)regionButtonClicked {
    if (self.regionButtonClickedBlock) {
        self.regionButtonClickedBlock();
    }
}

- (void)mobileNumberValueChanged {
    if (self.mobileNumberChangedBlock) {
        self.mobileNumberChangedBlock(self.mobileTextField.text);
    }
}

@end;
