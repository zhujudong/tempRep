//
//  AccountOrderListViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/17/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountOrderListViewController.h"
#import "AccountOrderListOrderItemModel.h"
#import "AccountOrderListProductItemModel.h"
#import "AccountOrderListHeaderCell.h"
#import "AccountOrderListItemCell.h"
#import "AccountOrderListPendingActionCell.h"
#import "AccountOrderListCompleteActionCell.h"
#import "AccountOrderListShippedActionCell.h"
#import "AccountOrderInfoViewController.h"
#import "AccountOrderExpressViewController.h"
#import "EmptyView.h"
#import "LoginViewController.h"
#import "GDRefreshNormalHeader.h"
#import "GDRefreshAutoNormalFooter.h"

static CGFloat const ORDER_BUTTON_HEIGHT = 40.0;

@interface AccountOrderListViewController () {
    BOOL showHUD;
    BOOL refreshLoadData;
    NSInteger currentPage;
    NSInteger lastPage;
    NSMutableArray *orders;
}
@property (strong, nonatomic) UIButton *btnAllOrders;
@property (strong, nonatomic) UIButton *btnUnpaidOrders;
@property (strong, nonatomic) UIButton *btnUnshippedOrders;
@property (strong, nonatomic) UIButton *btnShippedOrders;
@property (strong, nonatomic) UIView *buttonBottomShadowView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AccountOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_order_list_title", nil);
    self.view.backgroundColor = [UIColor whiteColor];

    _btnAllOrders = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnAllOrders setTitle:NSLocalizedString(@"button_order_type_all", nil) forState:UIControlStateNormal];
    [_btnAllOrders setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
    _btnAllOrders.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnAllOrders.tag = 101;

    [_btnAllOrders addTarget:self action:@selector(switchOrderType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAllOrders];

    _btnUnpaidOrders = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnUnpaidOrders setTitle:NSLocalizedString(@"button_order_type_unpaid", nil) forState:UIControlStateNormal];
    [_btnUnpaidOrders setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
    _btnUnpaidOrders.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnUnpaidOrders.tag = 102;
    [_btnUnpaidOrders addTarget:self action:@selector(switchOrderType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnUnpaidOrders];

    _btnUnshippedOrders = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnUnshippedOrders setTitle:NSLocalizedString(@"button_order_type_unshipped", nil) forState:UIControlStateNormal];
    [_btnUnshippedOrders setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
    _btnUnshippedOrders.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnUnshippedOrders.tag = 103;
    [_btnUnshippedOrders addTarget:self action:@selector(switchOrderType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnUnshippedOrders];

    _btnShippedOrders = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnShippedOrders setTitle:NSLocalizedString(@"button_order_type_shipped", nil) forState:UIControlStateNormal];
    [_btnShippedOrders setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
    _btnShippedOrders.titleLabel.font = [UIFont systemFontOfSize:12];
    _btnShippedOrders.tag = 104;
    [_btnShippedOrders addTarget:self action:@selector(switchOrderType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnShippedOrders];

    [_btnAllOrders mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.leading.equalTo(self.view);
        //make.trailing.equalTo(_btnUnpaidOrders.mas_leading);
        make.height.mas_equalTo(ORDER_BUTTON_HEIGHT);
        make.width.equalTo(@[_btnUnpaidOrders, _btnUnshippedOrders, _btnShippedOrders]);
    }];

    [_btnUnpaidOrders mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(_btnAllOrders.mas_trailing);
        make.height.mas_equalTo(ORDER_BUTTON_HEIGHT);
        make.width.equalTo(@[_btnAllOrders, _btnUnshippedOrders, _btnShippedOrders]);
    }];

    [_btnUnshippedOrders mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(_btnUnpaidOrders.mas_trailing);
        make.height.mas_equalTo(ORDER_BUTTON_HEIGHT);
        make.width.equalTo(@[_btnAllOrders, _btnUnpaidOrders, _btnShippedOrders]);
    }];

    [_btnShippedOrders mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.trailing.equalTo(self.view);
        make.leading.equalTo(_btnUnshippedOrders.mas_trailing);
        make.height.mas_equalTo(ORDER_BUTTON_HEIGHT);
        make.width.equalTo(@[_btnAllOrders, _btnUnpaidOrders, _btnUnshippedOrders]);
    }];

    _buttonBottomShadowView = [UIView new];
    _buttonBottomShadowView.backgroundColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1];

    [self.view addSubview:_buttonBottomShadowView];
    [_buttonBottomShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(_btnAllOrders.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 300.;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    _tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(ORDER_BUTTON_HEIGHT + 0.5, 0, 0, 0));
    }];

    if (_orderListType == nil) {
        _orderListType = @"";
    }

    // init some values;
    currentPage = 1;
    lastPage = currentPage;
    orders = [[NSMutableArray alloc] init];

    [_tableView registerClass:[AccountOrderListHeaderCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderListHeaderCell];
    [_tableView registerClass:[AccountOrderListItemCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderListItemCell];
    [_tableView registerClass:[AccountOrderListPendingActionCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderListPendingActionCell];
    [_tableView registerClass:[AccountOrderListCompleteActionCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderListCompleteActionCell];
    [_tableView registerClass:[AccountOrderListShippedActionCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderListShippedActionCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // 设置订单类型按钮底部线条
    if ([_orderListType isEqualToString:@""]) {
        [self setOrderTypeButtonBottomLine:_btnAllOrders];
    } else if ([_orderListType isEqualToString:@"unpaid"]) {
        [self setOrderTypeButtonBottomLine:_btnUnpaidOrders];
    } else if ([_orderListType isEqualToString:@"paid"]) {
        [self setOrderTypeButtonBottomLine:_btnUnshippedOrders];
    } else if ([_orderListType isEqualToString:@"shipped"]) {
        [self setOrderTypeButtonBottomLine:_btnShippedOrders];
    }

    refreshLoadData = YES;
    currentPage = 1;

    [self requestAPI];
}

// 设置订单类型按钮底部选中线条
- (void)setOrderTypeButtonBottomLine:(UIButton*)orderTypeButton {
    if ([orderTypeButton viewWithTag:100] == nil) {
        CGFloat lineHeight = 2.0;
        CGFloat lineMargin = 20.0;
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(lineMargin, orderTypeButton.frame.size.height - lineHeight, orderTypeButton.bounds.size.width - (lineMargin * 2), lineHeight)];
        bottomLine.backgroundColor = [UIColor colorWithRed:0.95 green:0.33 blue:0.33 alpha:1.0];
        [bottomLine setTag:100];

        [orderTypeButton addSubview:bottomLine];
    } else {
        UIView *bottomLine = [orderTypeButton viewWithTag:100];
        bottomLine.backgroundColor = [UIColor colorWithRed:0.95 green:0.33 blue:0.33 alpha:1.0];
    }
}

// 清除订单类型按钮底部线条
- (void)hideOrderTypeButtonBottomLine {
    for (int i = 101; i <= 104; i++) {
        if ([self.view viewWithTag:i] != nil) {
            UIButton *btn = [self.view viewWithTag:i];
            if ([btn viewWithTag:100] != nil) {
                UIView *bottomLine = [btn viewWithTag:100];
                bottomLine.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    _tableView.backgroundView = nil;

    if (currentPage <= lastPage) {
        if (showHUD) {
            showHUD = NO;
            [MBProgressHUD showLoadingHUDToView:self.view];
        }

        NSDictionary *params = @{@"status": [NSString stringWithString:_orderListType],
                                 @"page": [NSNumber numberWithInteger:currentPage],
                                 };

        [[Network sharedInstance] GET:@"orders" params:params callback:^(NSDictionary *data, NSString *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

            if (data) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                if (weakSelf.tableView.mj_header.isRefreshing) {
                    [weakSelf.tableView.mj_header endRefreshing];
                }

                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }

                AccountOrderListModel *orderListModel = [[AccountOrderListModel alloc] initWithDictionary:data error:nil];

                currentPage = orderListModel.currentPage + 1;
                lastPage = orderListModel.lastPage;

                if (refreshLoadData) {
                    refreshLoadData = NO;
                    [orders removeAllObjects];
                }

                if (orderListModel.orders.count) {
                    [orders addObjectsFromArray:orderListModel.orders];
                }

                [self.tableView reloadData];

                if (orders.count <= 0) {
                    weakSelf.tableView.mj_header = nil;
                    weakSelf.tableView.mj_footer = nil;

                    weakSelf.tableView.backgroundView = [self emptyView];
                } else {
                    [weakSelf addMJRefreshHeader];
                    [weakSelf addMJRefreshFooter];
                }

                if (currentPage > lastPage) {
                    weakSelf.tableView.mj_footer = nil;
                }
            }
        }];
    }
}

- (void)addMJRefreshHeader {
    if (self.tableView.mj_header == nil) {
        self.tableView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
            showHUD = YES;
            self.tableView.mj_footer = nil;

            refreshLoadData = YES;

            currentPage = 1;
            lastPage = currentPage;

            [self requestAPI];
        }];
    }
}

- (void)addMJRefreshFooter {
    if (self.tableView.mj_footer == nil) {
        self.tableView.mj_footer = [GDRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestAPI];
        }];
    }
}

- (EmptyView *)emptyView {
    currentPage = 1;
    lastPage = currentPage;

    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, -200, self.view.bounds.size.width, self.view.bounds.size.height)];
    emptyView.textLabel.text = NSLocalizedString(@"empty_no_orders", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];

    return emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //  AccountOrderListOrderItemModel *orderModel = [orders objectAtIndex:section];
    //  return orderModel.products.count + 2;
    return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountOrderListOrderItemModel *orderModel = [orders objectAtIndex:indexPath.section];

    id cell = nil;

    switch (indexPath.row) {
        case 0: { //Header
            cell = [self createOrderListHeaderCell:indexPath];
            break;
        }
        case 1: { //Product list
            cell = [self createOrderProductListCell:indexPath];
            break;
        }
        case 2: { //Action
            if ([orderModel.orderStatusCode isEqualToString:@"unpaid"]) {
                cell = [self createOrderListPendingActionCell:indexPath];
            } else if ([orderModel.orderStatusCode isEqualToString:@"paid"]) {
                cell = [self createOrderListCompleteActionCell:indexPath];
            } else if ([orderModel.orderStatusCode isEqualToString:@"shipped"]) {
                cell = [self createOrderListShippedActionCell:indexPath];
            } else { //complete and others
                cell = [self createOrderListCompleteActionCell:indexPath];
            }
            break;
        }
    }

    return cell;
}

- (AccountOrderListHeaderCell*)createOrderListHeaderCell:(NSIndexPath*) indexPath {
    AccountOrderListHeaderCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderListHeaderCell forIndexPath:indexPath];

    AccountOrderListOrderItemModel *order = [orders objectAtIndex:indexPath.section];
    [cell setOrder:order];

    return cell;
}

- (AccountOrderListItemCell*)createOrderProductListCell:(NSIndexPath*) indexPath {
    __weak typeof(self) weakSelf = self;

    AccountOrderListItemCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderListItemCell forIndexPath:indexPath];
    AccountOrderListOrderItemModel *order = [orders objectAtIndex:indexPath.section];

    [cell setProducts:order.products];

    cell.orderClickedBlock = ^(void) {
        AccountOrderInfoViewController *nextVC = [AccountOrderInfoViewController new];
        nextVC.orderId = order.orderId;
        [weakSelf.navigationController pushViewController:nextVC animated:YES];
    };

    return cell;
}

- (AccountOrderListPendingActionCell*)createOrderListPendingActionCell:(NSIndexPath*) indexPath {
    __weak typeof(self) weakSelf = self;

    AccountOrderListPendingActionCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderListPendingActionCell forIndexPath:indexPath];
    AccountOrderListOrderItemModel *order = [orders objectAtIndex:indexPath.section];

    [cell setOrder:order];

    cell.cancelButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf goToOrderInfoVC:orderId];
    };

    cell.payButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf goToOrderInfoVC:orderId];
    };

    return cell;
}

- (AccountOrderListCompleteActionCell*)createOrderListCompleteActionCell:(NSIndexPath*) indexPath {
    AccountOrderListCompleteActionCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderListCompleteActionCell forIndexPath:indexPath];
    AccountOrderListOrderItemModel *order = [orders objectAtIndex:indexPath.section];

    [cell setOrder:order];

    __weak typeof(self) weakSelf = self;

    cell.expressButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf goToExpressVC:orderId];
    };

    cell.viewButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf goToOrderInfoVC:orderId];
    };

    return cell;
}

- (AccountOrderListShippedActionCell*)createOrderListShippedActionCell:(NSIndexPath*) indexPath {
    AccountOrderListShippedActionCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderListShippedActionCell forIndexPath:indexPath];
    AccountOrderListOrderItemModel *order = [orders objectAtIndex:indexPath.section];

    [cell setOrder:order];

    __weak typeof(self) weakSelf = self;

    cell.expressButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf goToExpressVC:orderId];
    };

    cell.completeButtonClickedBlock = ^(NSString *orderId) {
        [weakSelf completeOrder:orderId];
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountOrderListOrderItemModel *orderModel = [orders objectAtIndex:indexPath.section];

    AccountOrderInfoViewController *nextVC = [AccountOrderInfoViewController new];
    nextVC.orderId = orderModel.orderId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == orders.count - 1) {
        return 10.0;
    }
    return 0.0001;
}

- (void)goToExpressVC:(NSString *)orderId {
    AccountOrderExpressViewController *nextViewController = [AccountOrderExpressViewController new];
    nextViewController.orderId = orderId;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)goToOrderInfoVC:(NSString *)orderId {
    NSLog(@"view order: %@", orderId);

    AccountOrderInfoViewController *nextVC = [AccountOrderInfoViewController new];
    nextVC.orderId = orderId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)completeOrder:(NSString *)orderId {
    NSLog(@"Complete order: %@", orderId);

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"alert_finish_order", nil) preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel", nil) style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:cancelAction];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_finish_order", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestCompleteOrderAPI:orderId];
            }];
            [alert addAction:okAction];

            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}

- (void)requestCompleteOrderAPI:(NSString *)orderId {
    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:[NSString stringWithFormat:@"orders/%@/complete", orderId] params:@{@"id": orderId} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_finish_order_success", nil)];

            currentPage = 1;
            refreshLoadData = YES;
            [self requestAPI];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)switchOrderType:(UIButton *)sender {
    [self hideOrderTypeButtonBottomLine];

    switch (sender.tag) {
        case 101: // all
            _orderListType = @"";
            [self setOrderTypeButtonBottomLine:_btnAllOrders];
            break;
        case 102: //unpaid
            _orderListType = @"unpaid";
            [self setOrderTypeButtonBottomLine:_btnUnpaidOrders];
            break;
        case 103: //unshipped
            _orderListType = @"paid";
            [self setOrderTypeButtonBottomLine:_btnUnshippedOrders];
            break;
        case 104: //shipped
            _orderListType = @"shipped";
            [self setOrderTypeButtonBottomLine:_btnShippedOrders];
            break;
    }

    refreshLoadData = YES;
    currentPage = 1;

    if (_tableView.numberOfSections > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    [self requestAPI];
}
@end
