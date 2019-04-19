//
//  AccountReturnListViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountReturnListViewController.h"
#import "AccountReturnDetailViewController.h"
#import "AccountReturnListItemCell.h"
#import "AccountReturnListModel.h"
#import "AccountReturnListItemModel.h"
#import "AccountReturnDetailViewController.h"
#import "LoginViewController.h"
#import "EmptyView.h"

@interface AccountReturnListViewController () {
    AccountReturnListModel *returnsModel;
    BOOL showHUD;
}

@end

@implementation AccountReturnListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    showHUD = YES;
    self.title = NSLocalizedString(@"text_account_return_list_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 160.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountReturnListItemCell class] forCellReuseIdentifier:kCellIdentifier_AccountReturnListItemCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self requestAPI];
}

- (void)requestAPI {
    self.tableView.backgroundView = nil;

    if (showHUD) {
        showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }

    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] GET:@"order_returns" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            returnsModel = [[AccountReturnListModel alloc] initWithDictionary:data error:nil];
            [weakSelf.tableView reloadData];
            if (returnsModel.orderReturns.count <= 0) {
                [weakSelf emptyView];
            }
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)emptyView {
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    emptyView.textLabel.text = NSLocalizedString(@"empty_no_return", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.backgroundView = emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return returnsModel.orderReturns.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountReturnListItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountReturnListItemCell];

    AccountReturnListItemModel *returnModel = [returnsModel.orderReturns objectAtIndex:indexPath.section];
    [cell setReturnModel:returnModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountReturnListItemModel *returnModel = [returnsModel.orderReturns objectAtIndex:indexPath.section];

    AccountReturnDetailViewController *nextVC = [AccountReturnDetailViewController new];
    nextVC.returnId = returnModel.returnId;

    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
