//
//  AccountConnectViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 12/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AccountConnectViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

static CGFloat const AVATAR_WIDTH = 100.0;
static CGFloat const BUTTON_HEIGHT = 44.0;

@interface AccountConnectViewController ()
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UILabel *firstnameLabel, *noticeLabel, *registerLabel, *connectLabel;
@property (strong, nonatomic) UIButton *registerButton, *connectButton;
@end

@implementation AccountConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"label_account_connect_vc_title", nil);
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    _avatarImageView = [UIImageView new];
    _avatarImageView.layer.cornerRadius = AVATAR_WIDTH / 2;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 2;
    [_avatarImageView setClipsToBounds:YES];

    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_social.avatar] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            _avatarImageView.alpha = 0.2;
            [UIView animateWithDuration:CONFIG_IMAGE_FADE_IN_DURATION animations:^{
                _avatarImageView.alpha = 1.0;
            }];
        }
    }];

    [self.view addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(AVATAR_WIDTH, AVATAR_WIDTH));
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
    }];

    _firstnameLabel = [UILabel new];
    _firstnameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"label_account_connect_welcome", nil), _social.fullname];
    _firstnameLabel.font = [UIFont systemFontOfSize:14];
    _firstnameLabel.textColor = [UIColor colorWithHexString:@"777777" alpha:1];

    [self.view addSubview:_firstnameLabel];
    [_firstnameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).offset(20);
        make.leading.equalTo(self.view).offset(10);
    }];

    _noticeLabel = [UILabel new];
    _noticeLabel.text = NSLocalizedString(@"label_account_connect_notice", nil);
    _noticeLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
    _noticeLabel.font = [UIFont systemFontOfSize:14];

    [self.view addSubview:_noticeLabel];
    [_noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstnameLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
    }];

    _registerLabel = [UILabel new];
    _registerLabel.textColor = [UIColor colorWithHexString:@"707070" alpha:1];
    _registerLabel.font = [UIFont systemFontOfSize:14];
    _registerLabel.text = NSLocalizedString(@"label_account_connect_register", nil);

    [self.view addSubview:_registerLabel];
    [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_noticeLabel.mas_bottom).offset(30);
        make.leading.equalTo(self.view).offset(10);
    }];

    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:NSLocalizedString(@"button_account_connect_register", nil) forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _registerButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    _registerButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    [_registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.top.equalTo(_registerLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
    }];

    _connectLabel = [UILabel new];
    _connectLabel.textColor = [UIColor colorWithHexString:@"707070" alpha:1];
    _connectLabel.font = [UIFont systemFontOfSize:14];
    _connectLabel.text = NSLocalizedString(@"label_account_connect_connect", nil);

    [self.view addSubview:_connectLabel];
    [_connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_registerButton.mas_bottom).offset(30);
        make.leading.equalTo(self.view).offset(10);
    }];

    _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectButton setTitle:NSLocalizedString(@"button_account_connect_connect", nil) forState:UIControlStateNormal];
    [_connectButton setTitleColor:[UIColor colorWithHexString:@"252525" alpha:1] forState:UIControlStateNormal];
    _connectButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _connectButton.backgroundColor = [UIColor whiteColor];
    _connectButton.layer.cornerRadius = CONFIG_GENERAL_BORDER_RADIUS;
    _connectButton.layer.borderWidth = 0.5;
    _connectButton.layer.borderColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1].CGColor;
    [_connectButton addTarget:self action:@selector(connectButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_connectButton];
    [_connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BUTTON_HEIGHT);
        make.top.equalTo(_connectLabel.mas_bottom).offset(10);
        make.leading.and.trailing.equalTo(_registerButton);
    }];
}

- (void)connectButtonClicked {
    LoginViewController *nextVC = [LoginViewController new];
    nextVC.social = _social;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)registerButtonClicked {
    RegisterViewController *nextVC = [RegisterViewController new];
    nextVC.social = _social;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
