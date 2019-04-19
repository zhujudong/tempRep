//
//  LocationSelectorCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 22/10/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "LocationSelectorCell.h"
#import "LocationModel.h"
#import "GDLocationTableSelectModalView.h"

static CGFloat const CELL_HEIGHT = 50.0;

@interface LocationSelectorCell()
@property(strong, nonatomic) LocationModel *location;
//@property (strong, nonatomic) GDLocationTableSelectView *locationTableSelectView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIWindow *window;
@end

@implementation LocationSelectorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        _window = [UIApplication.sharedApplication keyWindow];

        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitleColor:[UIColor colorWithHexString:@"4A4A4A" alpha:1] forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.leading.equalTo(self.contentView).offset(10);
            make.height.mas_equalTo(CELL_HEIGHT).priorityHigh();
        }];
    }

    return self;
}

- (void)buttonClicked {
    // Notify parent tableview VC to dismiss keyboard
    if (_viewController) {
        [_viewController.view endEditing:YES];
    }

    if (_location) {
        [self showLocationSelectionModalView];
    } else {
        [self loadLocationData];
    }
}

- (void)setAddress:(AccountAddressItemModel *)address {
    if (address) {
        _address = address;
    } else {
        _address = [[AccountAddressItemModel alloc] init];
    }
    [self updateButtonText];
}

#pragma mark - API
- (void)loadLocationData {
    __weak typeof(self) weakSelf = self;

    NSDictionary *params = @{@"multi_country": CONFIG_ADDRESS_CHINA_FORMAT ? @"0" : @"1"};
    [MBProgressHUD showLoadingHUDToView:weakSelf.window];
    [[Network sharedInstance] GET:@"regions" params:params callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.window animated:NO];
            [MBProgressHUD showToastToView:weakSelf.window withMessage:error];
            return;
        }

        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.window animated:YES];
            weakSelf.location = [[LocationModel alloc] initWithDictionary:data error:nil];
            if (weakSelf.location) {
                [weakSelf showLocationSelectionModalView];
            } else {
                [MBProgressHUD showToastToView:_window withMessage:@"国家/区域数据格式错误！"];
            }
        }
    }];
}

- (void)showLocationSelectionModalView {
    GDLocationTableSelectModalView *modalView = [[GDLocationTableSelectModalView alloc] initWithFrame:_window.frame];
    modalView.location = _location;
    [modalView initSelectedRows:[_location mapLocationIdsToRows:_address]];

    __weak typeof(self) weakSelf = self;
    modalView.locationValueChanged = ^(NSArray *names, NSArray *ids) {
        [weakSelf.address setLocationIdsInOrderedArray:ids];
        [weakSelf.button setTitle:[names componentsJoinedByString:@" "] forState:UIControlStateNormal];

        if (weakSelf.locationValueChangedBlock) {
            weakSelf.locationValueChangedBlock(weakSelf.address);
        }
    };
    [modalView show];
}

- (void)updateButtonText {
    NSString *buttonText;
    NSString *locationString = [_address stringifyLocation];
    if (locationString) {
        buttonText = locationString;
    } else {
        buttonText = NSLocalizedString(@"label_select_location", nil);
    }

    [_button setTitle:buttonText forState:UIControlStateNormal];
}

@end
