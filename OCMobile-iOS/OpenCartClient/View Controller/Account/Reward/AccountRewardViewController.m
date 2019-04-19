//
//  AccountRewardViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountRewardViewController.h"
#import "AccountRewardItemCell.h"
#import "AccountRewardSummaryCell.h"
#import "AccountRewardListModel.h"
#import "AccountRewardHistoryModel.h"
#import "LoginViewController.h"

@interface AccountRewardViewController () {
    AccountRewardListModel *rewardsModel;
    BOOL showHUD;
}

@end

@implementation AccountRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //init
    showHUD = YES;
    self.title = NSLocalizedString(@"text_account_reward_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountRewardSummaryCell class] forCellReuseIdentifier:kCellIdentifier_AccountRewardSummaryCell];
    [self.tableView registerClass:[AccountRewardItemCell class] forCellReuseIdentifier:kCellIdentifier_AccountRewardItemCell];

    [self requestAPI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)requestAPI{
    if (showHUD) {
        showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }

    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:@"account/me/rewards" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            rewardsModel = [[AccountRewardListModel alloc] initWithDictionary:data error:nil];
            [weakSelf.tableView reloadData];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;

        case 1:
            return rewardsModel.rewards.count;
            break;
    }

    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;

    switch (indexPath.section) {
        case 0:
            cell = [self createAccountRewardSummaryCell:indexPath];
            break;
        case 1:
            cell = [self createAccountRewardItemCell:indexPath];
            break;
    }

    return cell;
}

- (AccountRewardSummaryCell *)createAccountRewardSummaryCell:(NSIndexPath*) indexPath {
    AccountRewardSummaryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountRewardSummaryCell forIndexPath:indexPath];

    cell.rewardTotalLabel.text = [NSString stringWithFormat:@"%ld", (long)rewardsModel.rewardTotal];

    return cell;
}

- (AccountRewardItemCell *)createAccountRewardItemCell:(NSIndexPath*) indexPath {
    AccountRewardItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountRewardItemCell forIndexPath:indexPath];

    AccountRewardHistoryModel *reward = [rewardsModel.rewards objectAtIndex:indexPath.row];

    [cell setReward:reward];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 0.0001;
            break;
        case 1:
            return 10.;
            break;
    }

    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

@end
