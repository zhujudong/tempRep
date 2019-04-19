//
//  AccountOrderExpressViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderExpressViewController.h"
#import "AccountOrderExpressInfoCell.h"
#import "AccountOrderExpressItemCell.h"
#import "AccountOrderExpressesModel.h"
#import "AccountOrderExpressModel.h"
#import "EmptyView.h"
#import "LoginViewController.h"

@interface AccountOrderExpressViewController () {
    AccountOrderExpressesModel *expressesModel;
}

@end

@implementation AccountOrderExpressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_shipment_track_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 20.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountOrderExpressInfoCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderExpressInfoCell];
    [self.tableView registerClass:[AccountOrderExpressItemCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderExpressItemCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self requestAPI];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    self.tableView.backgroundView = nil;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [[Network sharedInstance] GET:[NSString stringWithFormat:@"orders/%@/tracks", _orderId] params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];

        if (data) {
            expressesModel = [[AccountOrderExpressesModel alloc] initWithDictionary:data error:nil];
            if (expressesModel.expresses) {
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf showEmptyView];
            }
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            [weakSelf showEmptyView];
        }
    }];
}

- (void)showEmptyView {
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    emptyView.textLabel.text = NSLocalizedString(@"empty_not_order_tracks", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.backgroundView = emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return expressesModel.expresses.count * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section % 2 == 0) {
        return 1;
    } else {
        AccountOrderExpressModel *expressModel = [expressesModel.expresses objectAtIndex:section / 2];
        return expressModel.traces.count;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;

    if (indexPath.section % 2 == 0) {
        cell = [self createAccountOrderExpressInfoCell:indexPath];
    } else {
        cell = [self createAccountOrderExpressItemCell:indexPath];
    }

    return cell;
}

- (AccountOrderExpressInfoCell *)createAccountOrderExpressInfoCell:(NSIndexPath *)indexPath {
    AccountOrderExpressInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderExpressInfoCell forIndexPath:indexPath];

    AccountOrderExpressModel *expressModel = [expressesModel.expresses objectAtIndex:indexPath.section / 2];

    [cell setExpressModel:expressModel];

    return cell;
}

- (AccountOrderExpressItemCell *)createAccountOrderExpressItemCell:(NSIndexPath *)indexPath {
    AccountOrderExpressItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderExpressItemCell forIndexPath:indexPath];

    AccountOrderExpressModel *expressModel = [expressesModel.expresses objectAtIndex:indexPath.section / 2];
    AccountOrderExpressTraceModel *traceModel = [expressModel.traces objectAtIndex:indexPath.row];

    [cell setTraceModel:traceModel];

    if (indexPath.row == 0) {
        [cell setDotStyleFirst];
    } else if (indexPath.row == expressModel.traces.count - 1) {
        [cell setDotStyleLast];
    } else {
        [cell setDotStyleMiddle];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

@end
