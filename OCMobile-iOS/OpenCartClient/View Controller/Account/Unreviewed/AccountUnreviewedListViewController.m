//
//  AccountUnreviewedListViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountUnreviewedListViewController.h"
#import "AccountUnreviewedFormViewController.h"
#import "AccountUnreviewedListCell.h"
#import "AccountUnreviewedProductsModel.h"
#import "AccountUnreviewedProductModel.h"
#import "EmptyView.h"
#import "LoginViewController.h"

@interface AccountUnreviewedListViewController ()
@property (strong, nonatomic) AccountUnreviewedProductsModel *productsModel;
@property (nonatomic) BOOL showHUD;
@end

@implementation AccountUnreviewedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_unreviewed_list_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 120.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[AccountUnreviewedListCell class] forCellReuseIdentifier:kCellIdentifier_AccountUnreviewedListCell];

    _showHUD = YES;
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

    if (_showHUD) {
        _showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }

    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"account/me/order_products" params:@{@"type":@"unreviewed"} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            _productsModel = [[AccountUnreviewedProductsModel alloc] initWithDictionary:data error:nil];
            [weakSelf.tableView reloadData];
            if (_productsModel.products.count <= 0) {
                [weakSelf emptyView];
            }
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)emptyView {
    if (_productsModel.products.count <= 0) {
        _showHUD = YES;
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
        emptyView.textLabel.text = NSLocalizedString(@"empty_no_unreviewed_items", nil);
        [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];

        self.tableView.backgroundView = emptyView;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _productsModel.products.count ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _productsModel.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountUnreviewedListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountUnreviewedListCell];

    AccountUnreviewedProductModel *product = [_productsModel.products objectAtIndex:indexPath.row];
    [cell setProduct:product];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountUnreviewedProductModel *product = [_productsModel.products objectAtIndex:indexPath.row];
    AccountUnreviewedFormViewController *nextVC = [[AccountUnreviewedFormViewController alloc] init];
    nextVC.orderProductId = product.orderProductId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
