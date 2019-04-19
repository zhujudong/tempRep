//
//  AccountReturnDetailViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnDetailViewController.h"
#import "AccountReturnDetailHeaderCell.h"
#import "AccountReturnDetailGeneralInfoCell.h"
#import "AccountReturnDetailDescriptionCell.h"
#import "AccountReturnDetailHistoryCell.h"
#import "AccountReturnInfoModel.h"
#import "AccountReturnInfoHistoryModel.h"
#import "LoginViewController.h"

@interface AccountReturnDetailViewController () {
    AccountReturnInfoModel *returnModel;
    BOOL showHUD;
}

@end

@implementation AccountReturnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_return_info_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountReturnDetailHeaderCell class] forCellReuseIdentifier:kCellIdentifier_AccountReturnDetailHeaderCell];
    [self.tableView registerClass:[AccountReturnDetailGeneralInfoCell class] forCellReuseIdentifier:kCellIdentifier_AccountReturnDetailGeneralInfoCell];
    [self.tableView registerClass:[AccountReturnDetailDescriptionCell class] forCellReuseIdentifier:kCellIdentifier_AccountReturnDetailDescriptionCell];
    [self.tableView registerClass:[AccountReturnDetailHistoryCell class] forCellReuseIdentifier:kCellIdentifier_AccountReturnDetailHistoryCell];

    showHUD = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self requestAPI];
}

- (void)requestAPI {
    if (showHUD) {
        showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:[NSString stringWithFormat:@"order_returns/%ld", (long)_returnId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            returnModel = [[AccountReturnInfoModel alloc] initWithDictionary:data error:nil];
            if (returnModel != nil) {
                [weakSelf.tableView reloadData];
            }
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:error];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return returnModel ? (returnModel.histories.count ? 3 : 2) : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0: //General Info
            return 2;
            break;
        case 1: //Description
            return 2;
        case 2: //History
            return returnModel.histories.count + 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;

    switch (indexPath.section) {
        case 0: {//General Info
            switch (indexPath.row) {
                case 0: {
                    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"text_return_id", nil), returnModel.returnId];
                    NSString *subtitle = [NSString stringWithFormat:NSLocalizedString(@"text_status", nil), returnModel.statusName];

                    cell = (AccountReturnDetailHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnDetailHeaderCell];

                    [cell setTitle:title subtitle:subtitle];

                    break;
                }
                case 1: {
                    cell = (AccountReturnDetailGeneralInfoCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnDetailGeneralInfoCell];
                    [cell setReturnModel:returnModel];
                    break;
                }
            }
            break;
        }
        case 1: { //Description
            switch (indexPath.row) {
                case 0: {
                    cell = (AccountReturnDetailHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnDetailHeaderCell];

                    [cell setTitle:NSLocalizedString(@"title_return_description", nil) subtitle:nil];
                    break;
                }
                case 1:
                    cell = (AccountReturnDetailDescriptionCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnDetailDescriptionCell];

                    [cell setDesc:returnModel.comment];
                    break;
            }
            break;
        }
        case 2: { //History
            switch (indexPath.row) {
                case 0:
                    cell = (AccountReturnDetailHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnDetailHeaderCell];

                    [cell setTitle:NSLocalizedString(@"title_return_progress", nil) subtitle:nil];

                    break;
                default:
                    cell = (AccountReturnDetailHistoryCell *)[self.tableView dequeueReusableCellWithIdentifier:@"AccountReturnDetailHistoryCell"];

                    AccountReturnInfoHistoryModel *history = [returnModel.histories objectAtIndex:indexPath.row - 1];

                    [cell setHistory:history];
                    
                    break;
            }
            break;
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}
@end
