//
//  AccountSettingViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "LabelWithDescriptionCell.h"
#import "AccountAboutViewController.h"
#import "GDTableFormFooterButtonView.h"
#import "Customer.h"
#import "AccountAPI.h"
#import "AccountLanguageViewController.h"

@interface AccountSettingViewController ()
@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_account_setting_title", nil);
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[LabelWithDescriptionCell class] forCellReuseIdentifier:kCellIdentifier_LabelWithDescriptionCell];
    
    if ([[Customer sharedInstance] isLogged]) {
        GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [confirmButtonView.button setTitle:NSLocalizedString(@"text_account_logout", nil) forState:UIControlStateNormal];
        [confirmButtonView.button addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.tableView.tableFooterView = confirmButtonView;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LabelWithDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LabelWithDescriptionCell forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            [cell setPlaceholder:NSLocalizedString(@"label_account_setting_cache", nil) description:NSLocalizedString(@"label_account_setting_cache_calculating", nil)];
            
            [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                NSString *cacheSize = totalSize ? [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] getSize] countStyle:NSByteCountFormatterCountStyleFile] : @"0KB";
                
                [cell setPlaceholder:NSLocalizedString(@"label_account_setting_cache", nil) description:cacheSize];
            }];
            break;
        }
        case 1: {
            NSString *languageName = [[System sharedInstance] languageName];
            [cell setPlaceholder:NSLocalizedString(@"label_account_setting_language", nil) description:languageName];
            break;
        }
        case 2: {
            [cell setPlaceholder:NSLocalizedString(@"label_account_setting_about", nil) description:@""];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self clearImageCache];
            break;
        case 1:
            [self goToLanguageVC];
            break;
        case 2:
            [self goToAboutVC];
            break;
    }
}

- (void)clearImageCache {
    [MBProgressHUD showLoadingHUDToView:self.view];
    SDImageCache *sdImageCache = [SDImageCache sharedImageCache];
    
    [sdImageCache clearMemory];
    [sdImageCache clearDiskOnCompletion:^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_image_cache_clear_success", nil)];
        
        LabelWithDescriptionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (cell) {
            [cell setPlaceholder:NSLocalizedString(@"label_account_setting_cache", nil) description:@"0KB"];
        }
    }];
}

- (void)logoutButtonClicked {
    NSLog(@"Logout button clicked");
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"text_account_logout", nil) message:NSLocalizedString(@"alert_logout", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_account_logout", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf logoutAndRefreshAccessToken];
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)logoutAndRefreshAccessToken {
    __weak typeof(self) weakSelf = self;
    
    [MBProgressHUD showLoadingHUDToView:weakSelf.navigationController.view];
    
    // Remove avatar from cache
    [[SDImageCache sharedImageCache] removeImageForKey:[Customer sharedInstance].avatar fromDisk:YES withCompletion:nil];
    [[Customer sharedInstance] logout];
    [[AccountAPI sharedInstance] requestNewAccessTokenWithBlock:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:NO];
            [MBProgressHUD showToastToView:self.navigationController.view withMessage:NSLocalizedString(@"toast_logout_success", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)goToAboutVC {
    AccountAboutViewController *nextVC = [[AccountAboutViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)goToLanguageVC {
    AccountLanguageViewController *nextVC = [[AccountLanguageViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}
@end
