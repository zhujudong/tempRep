//
//  AccountAboutViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 27/11/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountAboutViewController.h"

@interface AccountAboutViewController ()
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *appNameLabel, *descritionLabel, *versionLabel, *companyLabel, *copyrightLabel;
@property (strong, nonatomic) UIButton *urlButton;
@end

@implementation AccountAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_about", nil);

    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    _logoImageView.layer.cornerRadius = 20.0;
    _logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImageView.clipsToBounds = YES;

    [self.view addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
    }];

    _appNameLabel = [UILabel new];
    _appNameLabel.font = [UIFont systemFontOfSize:18];
    _appNameLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1];
    _appNameLabel.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [self.view addSubview:_appNameLabel];
    [_appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_logoImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];

    _descritionLabel = [UILabel new];
    _descritionLabel.font = [UIFont systemFontOfSize:16];
    _descritionLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
    _descritionLabel.text = NSLocalizedString(@"text_account_about_slogan", nil);
    [self.view addSubview:_descritionLabel];
    [_descritionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_appNameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];

    _versionLabel = [UILabel new];
    _versionLabel.font = [UIFont systemFontOfSize:12];
    _versionLabel.textColor = [UIColor colorWithHexString:@"999999" alpha:1];
    _versionLabel.text = [NSString stringWithFormat:@"v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:_versionLabel];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descritionLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];

    _copyrightLabel = [UILabel new];
    _copyrightLabel.font = [UIFont systemFontOfSize:12];
    _copyrightLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
    _copyrightLabel.text = NSLocalizedString(@"text_account_about_copyright", nil);
    [self.view addSubview:_copyrightLabel];
    [_copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.equalTo(self.view);
    }];

    _urlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_urlButton setTitle:NSLocalizedString(@"text_account_about_link_title", nil) forState:UIControlStateNormal];
    _urlButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_urlButton setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1] forState:UIControlStateNormal];
    [_urlButton addTarget:self action:@selector(urlButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_urlButton];
    [_urlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_copyrightLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];

    _companyLabel = [UILabel new];
    _companyLabel.font = [UIFont systemFontOfSize:12];
    _companyLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];
    _companyLabel.text = NSLocalizedString(@"text_account_about_company", nil);
    [self.view addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_urlButton.mas_top).offset(-10);
        make.centerX.equalTo(self.view);
    }];
}

- (void)urlButtonClicked {
    [[UIApplication sharedApplication]
     openURL:[NSURL URLWithString: NSLocalizedString(@"text_account_about_link_url", nil)]];
}
@end
