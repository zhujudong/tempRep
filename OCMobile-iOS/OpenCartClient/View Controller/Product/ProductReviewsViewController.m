//
//  ProductReviewsViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/10/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductReviewsViewController.h"
#import "ProductReviewReviewCell.h"
#import "ProductReviewListModel.h"
#import "ProductReviewItemModel.h"
#import <MJRefresh.h>
#import "EmptyView.h"
#import "GDRefreshNormalHeader.h"
#import "GDRefreshAutoNormalFooter.h"


@interface ProductReviewsViewController () {
    NSInteger currentPage;
    NSInteger lastPage;
    NSMutableArray *reviews;
    BOOL showHUD;
    BOOL refreshLoadData;
}
@end

@implementation ProductReviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"text_product_reviews_title", nil);
    
    // init some values;
    currentPage = 1;
    lastPage = currentPage;
    reviews = [[NSMutableArray alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    
    [self.tableView registerClass:[ProductReviewReviewCell class] forCellReuseIdentifier:kCellIdentifier_ProductReviewReviewItemCell];
    
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    
    [self requestAPI];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    self.tableView.backgroundView = nil;
    
    if (currentPage <= lastPage) {
        if (showHUD) {
            showHUD = NO;
            [MBProgressHUD showLoadingHUDToView:self.view];
        }
        
        
        NSDictionary *params = @{@"id": [NSNumber numberWithInteger:_productId],
                                 @"page": [NSNumber numberWithInteger:currentPage],
                                 };
        
        [[Network sharedInstance] GET:[NSString stringWithFormat:@"order_products/%ld/reviews", (long)_productId] params:params callback:^(NSDictionary *data, NSString *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            
            if (data) {
                if (weakSelf.tableView.mj_header.isRefreshing) {
                    [weakSelf.tableView.mj_header endRefreshing];
                }
                
                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                
                ProductReviewListModel *reviewListModel = [[ProductReviewListModel alloc] initWithDictionary:data error:nil];
                
                currentPage = reviewListModel.currentPage + 1;
                lastPage = reviewListModel.lastPage;
                
                if (reviewListModel.reviews.count) {
                    if (refreshLoadData) {
                        refreshLoadData = NO;
                        [reviews removeAllObjects];
                    }
                    
                    [reviews addObjectsFromArray:reviewListModel.reviews];
                    
                    [weakSelf.tableView reloadData];
                }
                
                if (reviews.count <= 0) {
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
            
            if (error) {
                if (weakSelf.tableView.mj_header.isRefreshing) {
                    [weakSelf.tableView.mj_header endRefreshing];
                }
                
                if (weakSelf.tableView.mj_footer.isRefreshing) {
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
                
                NSLog(@"%@", error);
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
    emptyView.textLabel.text = NSLocalizedString(@"empty_no_reviews", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];
    
    return emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return reviews.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    
    cell = [self createReviewCellAtIndexPath:indexPath];
    
    return cell;
}

- (ProductReviewReviewCell *)createReviewCellAtIndexPath:(NSIndexPath*)indexPath {
    ProductReviewReviewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductReviewReviewItemCell forIndexPath:indexPath];
    
    ProductReviewItemModel *review = [reviews objectAtIndex:indexPath.section];
    
    [cell setReview:review];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

@end
