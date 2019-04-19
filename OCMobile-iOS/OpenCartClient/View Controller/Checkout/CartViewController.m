//
//  CartViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CartViewController.h"
#import "CartProductItemCell.h"
#import "CartTotalItemCell.h"
#import "StatusModel.h"
#import "CartModel.h"
#import "CartProductItemModel.h"
#import "ProductViewController.h"
#import "LoginViewController.h"
#import "EmptyView.h"
#import "Customer.h"
#import "UITabBarController+CartNumber.h"
#import "CheckoutModel.h"
#import "CheckoutViewController.h"
#import "GDRefreshNormalHeader.h"
#import "RDVTabBarController.h"
#import "RDVTabBarController+CartNumber.h"

static CGFloat const CHECKOUT_BUTTON_HEIGHT = 50.0;
static CGFloat const CHECKOUT_BUTTON_WIDTH = 120.0;

@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIBarButtonItem *navEditButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bottomBarBackgroundView;
@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UILabel *excludeShippingLabel;
@property (strong, nonatomic) UIButton *checkoutButton;
@property (strong, nonatomic) UIButton *checkAllButton;

@property (strong, nonatomic) CartModel *cart;
@property (nonatomic) BOOL isEditMode;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_cart_title", nil);
    self.view.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];

    _navEditButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"text_edit_mode_edit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(navEditButtonClicked)];
    self.navigationItem.rightBarButtonItem = _navEditButton;

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200.;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    _tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, CHECKOUT_BUTTON_HEIGHT + (self.hideTabBar ? 0 : [[System sharedInstance] tabBarHeight]), 0);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(inset);
    }];
    [_tableView registerClass:[CartProductItemCell class] forCellReuseIdentifier:[CartProductItemCell identifier]];
    [_tableView registerClass:[CartTotalItemCell class] forCellReuseIdentifier:kCellIdentifier_CartTotalItemCell];

    _checkoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_checkoutButton setTitle:NSLocalizedString(@"text_checkout_button_checkout", nil) forState:UIControlStateNormal];
    [_checkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _checkoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _checkoutButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    [_checkoutButton addTarget:self action:@selector(checkoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _checkoutButton.hidden = YES;
    [self.view addSubview:_checkoutButton];
    [_checkoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(CHECKOUT_BUTTON_WIDTH);
        make.height.mas_equalTo(CHECKOUT_BUTTON_HEIGHT);
        make.bottom.equalTo(self.view).mas_offset((self.hideTabBar ? 0 : ([[System sharedInstance] tabBarHeight])) * -1);
        make.trailing.equalTo(self.view);
    }];

    _bottomBarBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomBarBackgroundView.backgroundColor = [UIColor colorWithHexString:@"333333" alpha:1];
    _bottomBarBackgroundView.hidden = YES;
    [self.view addSubview:_bottomBarBackgroundView];
    [_bottomBarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CHECKOUT_BUTTON_HEIGHT);
        make.leading.equalTo(self.view.mas_leading);
        make.bottom.equalTo(self.checkoutButton);
        make.trailing.equalTo(_checkoutButton.mas_leading);
    }];

    _checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkAllButton setTitle:NSLocalizedString(@"button_cart_select_all", nil) forState:UIControlStateNormal];
    [_checkAllButton setTitle:NSLocalizedString(@"button_cart_select_all", nil) forState:UIControlStateSelected];
    _checkAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_checkAllButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [_checkAllButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    [_checkAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_checkAllButton addTarget:self action:@selector(checkAllButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBarBackgroundView addSubview:_checkAllButton];
    [_checkAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_bottomBarBackgroundView.mas_leading).offset(10);
        make.top.and.bottom.equalTo(_bottomBarBackgroundView);
    }];

    _totalLabel = [[UILabel alloc] init];
    _totalLabel.font = [UIFont systemFontOfSize:15];
    _totalLabel.textColor = [UIColor whiteColor];
    _totalLabel.text = NSLocalizedString(@"label_cart_calculating", nil);
    [_bottomBarBackgroundView addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomBarBackgroundView.mas_top).offset(10);
        make.trailing.equalTo(_bottomBarBackgroundView.mas_trailing).offset(-10);
    }];

    _excludeShippingLabel = [[UILabel alloc] init];
    _excludeShippingLabel.textColor = [UIColor whiteColor];
    _excludeShippingLabel.font = [UIFont systemFontOfSize:12];
    _excludeShippingLabel.text = NSLocalizedString(@"label_cart_exclude_shipping_fee", nil);
    [_bottomBarBackgroundView addSubview:_excludeShippingLabel];
    [_excludeShippingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBarBackgroundView.mas_bottom).offset(-5);
        make.trailing.equalTo(_bottomBarBackgroundView.mas_trailing).offset(-10);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.hideTabBar == NO && animated && self.rdv_tabBarController.tabBarHidden) {
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self requestAPI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (animated) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_cart.products.count > 0) {
        return _cart.products.count;
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _cart.products.count) {
        CartProductItemModel *product = [_cart.products objectAtIndex:indexPath.section];
        return [self createCartProductItemCell:indexPath forProduct:product];
    }

    return nil;
}

- (CartProductItemCell *)createCartProductItemCell:(NSIndexPath *) indexPath forProduct:(CartProductItemModel *)product {
    __weak typeof(self) weakSelf = self;

    CartProductItemCell *cell = [_tableView dequeueReusableCellWithIdentifier:[CartProductItemCell identifier] forIndexPath:indexPath];

    if (_isEditMode) {
        product.selected = [_cart isProductSelectedInEditMode:product.cartId];
    }

    [cell setProduct:product];

    NSString *cartId = product.cartId;
    cell.quantityChangedBlock = ^(NSInteger newQuantity) {
        [MBProgressHUD showLoadingHUDToView:weakSelf.view];

        [[Network sharedInstance] PUT:[NSString stringWithFormat:@"carts/%@", cartId] params:@{@"quantity": [NSNumber numberWithInteger:newQuantity]} callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                weakSelf.cart = [[CartModel alloc] initWithDictionary:data error:nil];
                [weakSelf updateUI];
            }

            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    };

    cell.productSelectChangedBlock = ^(BOOL selected) {
        if (weakSelf.isEditMode) {
            [weakSelf.cart toggleProductSelectionInEditMode:cartId];
            // Update Select All button status
            [weakSelf.checkAllButton setSelected:[weakSelf.cart isAllProductsSelectedInEditMode]];
        } else {
            [weakSelf requestSelectOrUnselectCartIdsAPI:cartId toSelected:selected];
        }
    };

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section < tableView.numberOfSections - 1) {
        return 0.01;
    }
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _cart.products.count) {
        CartProductItemModel *product = [_cart.products objectAtIndex:indexPath.section];
        [self goToProductVC:product.productId];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section < _cart.products.count) {
        return YES;
    }

    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CartProductItemModel *product = [_cart.products objectAtIndex:indexPath.section];

        [self requestDeleteAPI:@[product.cartId]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"text_checkout_button_delete", nil);
}

#pragma mark - API
- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    _cart = nil;
    [[Network sharedInstance] GET:@"carts" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf.tableView.mj_header endRefreshing];

        if (data) {
            weakSelf.cart = [[CartModel alloc] initWithDictionary:data error:nil];
        }

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }

        [weakSelf updateUI];
    }];
}

- (void)requestDeleteAPI:(NSArray *)cartIds {
    if (cartIds.count < 1) {
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];
    NSDictionary *deleteCartIds = @{@"cart_ids": cartIds};
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"carts/batch_destroy" params:deleteCartIds callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            weakSelf.cart = [[CartModel alloc] initWithDictionary:data error:nil];
            [weakSelf updateUI];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)requestSelectOrUnselectCartIdsAPI:(NSString *)cartId toSelected:(BOOL)selected {
    [MBProgressHUD showLoadingHUDToView:self.view];
    NSMutableArray *selectedCartIds = [[NSMutableArray alloc] init];
    if (cartId == nil) { //select all
        for (CartProductItemModel *product in _cart.products) {
            [selectedCartIds addObject:product.cartId];
        }
    } else {
        [selectedCartIds addObject:cartId];
    }

    NSString *requestUrl = selected ? @"carts/select" : @"carts/unselect";
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] PUT:requestUrl params:@{@"cart_ids": selectedCartIds} callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            weakSelf.cart = [[CartModel alloc] initWithDictionary:data error:nil];
            [weakSelf updateUI];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

#pragma mark - Action
- (void)checkoutButtonClicked {
    if (_isEditMode) {
        if ([_cart allSelectedCartIdsInEditMode].count < 1) {
            [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_item_selected_to_delete", nil)];
            return;
        }

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"text_sure_to_delete_items", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancelAction];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"text_sure_to_delete_items_title", nils) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestDeleteAPI:[_cart allSelectedCartIdsInEditMode]];
        }];
        [alert addAction:okAction];

        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    if (_isEditMode == NO) {
        if ([[Customer sharedInstance] isLogged] == NO) {
            [self showLoginVC];
            return;
        }

        NSArray *selectedCartIds = [_cart allSelectedCartIdsForCheckout];
        // No product selected
        if (selectedCartIds.count < 1) {
            [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"error_no_items_selected_to_checkout", nil)];
            return;
        }

        [self pushToCheckoutViewController];
    }
}

- (void)pushToCheckoutViewController {
    if ([[Customer sharedInstance] isLogged] == NO) {
        [self showLoginVC];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"checkout" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            CheckoutModel *checkout = [[CheckoutModel alloc] initWithDictionary:data error:nil];

            if (checkout == nil) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"error_checkout_system_error", nil)];
                return;
            }

            if (checkout.products.count < 1) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"error_checkout_no_product", nil)];
                return;
            }

            //Push to Checkout view controller
            CheckoutViewController *nextVC = [[CheckoutViewController alloc] init];
            nextVC.checkout = checkout;
            nextVC.pushedFromCart = YES;
            nextVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        }
    }];
}

- (void)navEditButtonClicked {
    _isEditMode = !_isEditMode;
    [_excludeShippingLabel setHidden:_isEditMode];

    if (_isEditMode) {
        _navEditButton.title = NSLocalizedString(@"text_edit_mode_end", nil);
        [_checkoutButton setTitle:NSLocalizedString(@"text_checkout_button_delete", nil) forState:UIControlStateNormal];
        [_checkAllButton setSelected:NO];
        _totalLabel.hidden = YES;

        [_cart removeAllProductsSelectedInEditMode];
        for (int i = 0; i < _cart.products.count; i++) {
            CartProductItemCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [cell setProductSelected:NO];
        }
    }

    // Checkout mode
    if (_isEditMode == NO) {
        _navEditButton.title = NSLocalizedString(@"text_edit_mode_edit", nil);
        [_checkoutButton setTitle:NSLocalizedString(@"text_checkout_button_checkout", nil) forState:UIControlStateNormal];
        [self requestAPI];
    }
}

- (void)goToProductVC:(NSInteger)productId {
    ProductViewController *nextVC = [ProductViewController new];
    [nextVC setHidesBottomBarWhenPushed:YES];
    nextVC.productId = productId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)checkAllButtonClicked {
    [_checkAllButton setSelected:!_checkAllButton.isSelected];

    if (_isEditMode) {
        if (_checkAllButton.isSelected) {
            [_cart makeAllProductsSelectedInEditMode];
        } else {
            [_cart removeAllProductsSelectedInEditMode];
        }
        for (int i = 0; i < _cart.products.count; i++) {
            CartProductItemCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [cell setProductSelected:_checkAllButton.isSelected];
        }

    } else {
        if (_checkAllButton.isSelected) { // Make all products selected
            [self requestSelectOrUnselectCartIdsAPI:nil toSelected:YES];
        } else { // Deselected all products
            [self requestSelectOrUnselectCartIdsAPI:nil toSelected:NO];
        }
    }
}

#pragma mark - Private
- (void)updateUI {
    if (_cart) {
        [[Customer sharedInstance] setCartNumber:_cart.totalQuantity];
        [self.rdv_tabBarController updateCartNumber];
    }

    // Exit edit mode
    _isEditMode = NO;

    [_checkoutButton setTitle:NSLocalizedString(@"text_checkout_button_checkout", nil) forState:UIControlStateNormal];
    [_checkoutButton setHidden:_cart.products.count < 1];
    [_totalLabel setHidden:_isEditMode];
    [_excludeShippingLabel setHidden:_isEditMode];

    __weak typeof(self) weakSelf = self;
    if (_cart.products.count < 1) {
        _navEditButton.title = nil;

        _tableView.mj_header = nil;
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        emptyView.iconImageView.image = [UIImage imageNamed:@"empty_cart"];
        emptyView.textLabel.text = NSLocalizedString(@"text_cart_empty", nil);
        [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];
        _tableView.backgroundView = emptyView;
        [_tableView reloadData];
        
        _totalLabel.text = nil;
        [_bottomBarBackgroundView setHidden:YES];
        return;
    }

    _navEditButton.title = NSLocalizedString(@"text_edit_mode_edit", nil);

    _tableView.backgroundView = nil;

    if (_tableView.mj_header == nil) {
        weakSelf.tableView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestAPI];
        }];
    }

    [_bottomBarBackgroundView setHidden:NO];

    // iPhone 5S
    if (SCREEN_WIDTH < 375) {
        _totalLabel.text = _cart.totalPriceFormat;
    } else {
        _totalLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_bottom_subtotal", nil), _cart.totalPriceFormat];
    }

    [self.tableView reloadData];
    [_checkAllButton setSelected:[_cart isAllProductsSelectedForCheckout]];
}
@end
