//
//  AccountWishlistViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 4/11/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountWishlistViewController.h"
#import "AccountWishlistCell.h"
#import "AccountWishlistModel.h"
#import "AccountWishlistProductItemModel.h"
#import "ProductViewController.h"
#import "EmptyView.h"
#import "LoginViewController.h"
#import "GDRefreshNormalHeader.h"

@interface AccountWishlistViewController ()
@property (strong, nonatomic) AccountWishlistModel *wishlist;
@property (nonatomic) BOOL showHUD;
@end

@implementation AccountWishlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_account_wishlist_title", nil);
    _showHUD = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    self.tableView.estimatedRowHeight = 200.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerClass:[AccountWishlistCell class] forCellReuseIdentifier:kCellIdentifier_AccountWishlistCell];
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
    if (_showHUD) {
        _showHUD = NO;
        [MBProgressHUD showLoadingHUDToView:self.view];
    }
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"wishlist?width=200&height=200" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.tableView.mj_header endRefreshing];
            
            _wishlist = [[AccountWishlistModel alloc] initWithDictionary:data error:nil];
            if (_wishlist.products.count) {
                if (weakSelf.tableView.mj_header == nil) {
                    weakSelf.tableView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
                        [weakSelf requestAPI];
                    }];
                }
            } else {
                weakSelf.tableView.mj_header = nil;
                [weakSelf showEmptyView];
            }
            
            [weakSelf.tableView reloadData];
        }
        
        if (error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            
            [weakSelf showEmptyView];
        }
    }];
}

- (void)showEmptyView {
    _showHUD = YES;
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds];
    emptyView.textLabel.text = NSLocalizedString(@"empty_wishlist_list", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.backgroundView = emptyView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _wishlist.products.count ? 1 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _wishlist.products.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountWishlistCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountWishlistCell forIndexPath:indexPath];
    
    AccountWishlistProductItemModel *product = [_wishlist.products objectAtIndex:indexPath.row];
    
    [cell setProduct:product];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountWishlistProductItemModel *product = [_wishlist.products objectAtIndex:indexPath.row];
    NSLog(@"selected product: %ld", (long)product.productId);
    ProductViewController *nextVC = [[ProductViewController alloc] init];
    nextVC.productId = product.productId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MBProgressHUD showLoadingHUDToView:self.view];
        AccountWishlistProductItemModel *product = [_wishlist.products objectAtIndex:indexPath.row];
        __weak typeof(self) weakSelf = self;
        
        [[Network sharedInstance] DELETE:[NSString stringWithFormat:@"wishlist/%ld", (long)product.productId] params:nil callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [weakSelf requestAPI];
            }
            
            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NSLocalizedString(@"text_delete", nil);
}

@end
