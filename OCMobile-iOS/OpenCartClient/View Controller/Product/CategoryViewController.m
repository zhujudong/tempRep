//
//  CategoryViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductGridCollectionViewCell.h"
#import "ProductViewController.h"
#import "EmptyView.h"
#import "GDSearchUIButton.h"
#import "GDNavigationBarWithSearch.h"
#import "SearchViewController.h"
#import "GDRefreshNormalHeader.h"
#import "GDRefreshAutoNormalFooter.h"
#import "FilterModalView.h"
#import "FilterCollectionModel.h"
#import "RDVTabBarController.h"

static CGFloat const NAVBAR_HEIGHT = 44.0;
static CGFloat const SORT_BUTTON_HEIGHT = 40.0;
static NSInteger const CELL_ITEM_PER_ROW = 2;
static CGFloat const CELL_GUTTER = 6.0;

typedef NS_ENUM(NSInteger, SortBy) {
    SortBySortOrder,
    SortBySales,
    SortByPrice,
    SortByRating,
    SortByViewed,
};

@interface CategoryViewController ()
@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) UIStackView *sortStackView;
@property (strong, nonatomic) UIButton *defaultButton, *saleButton, *priceButton, *ratingButton;
@property (strong, nonatomic) UIView *sortButtonBottomLine;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) FilterCollectionModel *filters;

@property (nonatomic) SortBy sortBy;
@property (nonatomic) BOOL sortOrderDESC;
@property (nonatomic) BOOL showHUD;
@property (nonatomic) BOOL refreshLoadData;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastPage;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init some values
    _currentPage = 1;
    _lastPage = _currentPage;
    _sortBy = SortBySortOrder;
    _sortOrderDESC = YES;
    _products = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    
    // Add back button to navigation bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    [leftButton setImageInsets:UIEdgeInsetsMake(1., -6., 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    GDSearchUIButton *searchButton;
    CGFloat searchBarViewWidth = SCREEN_WIDTH * 0.8;
    CGFloat searchBarViewHeight = NAVBAR_HEIGHT * 0.7;
    CGFloat searchBarViewX = 0;
    CGFloat searchBarViewY = ((NAVBAR_HEIGHT - searchBarViewHeight) * 0.5);
    searchButton = [[GDSearchUIButton alloc] initWithFrame:CGRectMake(searchBarViewX, searchBarViewY, searchBarViewWidth, searchBarViewHeight)];
    [searchButton addTarget:self action:@selector(selectSearchTab) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = searchButton;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button_filter", nil) style:UIBarButtonItemStylePlain target:self action:@selector(filterButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButton;

    _sortStackView = [[UIStackView alloc] init];
    _sortStackView.distribution = UIStackViewDistributionFillEqually;
    _sortStackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_sortStackView];

    // Add sort buttons
    _defaultButton = [self makeSortButtonWithTitle:@"button_category_sort_general"];
    [_sortStackView addArrangedSubview:_defaultButton];

    _saleButton = [self makeSortButtonWithTitle:@"button_category_sort_sales"];
    [_sortStackView addArrangedSubview:_saleButton];

    _priceButton = [self makeSortButtonWithTitle:@"button_category_sort_price"];
    [_sortStackView addArrangedSubview:_priceButton];

    _ratingButton = [self makeSortButtonWithTitle:@"button_category_sort_rating"];
    [_sortStackView addArrangedSubview:_ratingButton];
    
    [_sortStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(SORT_BUTTON_HEIGHT);
    }];
    
    //Add bottom border to sort buttons
    _sortButtonBottomLine = [UIView new];
    _sortButtonBottomLine.backgroundColor = [UIColor colorWithHexString:@"c8c7cc" alpha:1.];
    [self.view addSubview:_sortButtonBottomLine];
    [_sortButtonBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.leading.and.trailing.equalTo(self.view);
        make.top.equalTo(_sortStackView.mas_bottom);
    }];
    
    //Hide buttons
    [_sortStackView setHidden:YES];
    [_sortButtonBottomLine setHidden:YES];
    
    // Init collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = CELL_GUTTER;
    layout.minimumInteritemSpacing = CELL_GUTTER;
    layout.sectionInset = UIEdgeInsetsMake(CELL_GUTTER, 0, 0, 0);
    CGFloat width = (SCREEN_WIDTH - (CELL_ITEM_PER_ROW * CELL_GUTTER) + CELL_GUTTER) / CELL_ITEM_PER_ROW;
    layout.itemSize = CGSizeMake(width, width + (14 * 2) + (CELL_GUTTER * 3));
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    [_collectionView registerClass:[ProductGridCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_ProductGridCollectionViewCell];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sortButtonBottomLine.mas_bottom);
        make.leading.bottom.and.trailing.equalTo(self.view);
    }];
    
    [self requestAPI];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - API
- (void)requestAPI {
    _collectionView.backgroundView = nil;
    
    if (_currentPage <= _lastPage) {
        if (_showHUD) {
            _showHUD = NO;
            [MBProgressHUD showLoadingHUDToView:self.view];
        }

        NSDictionary *basicParams = @{
                                      @"page": [NSNumber numberWithInteger:_currentPage],
                                      @"sort": [self convertSortByToString],
                                      @"order": _sortOrderDESC ? @"desc" : @"asc"
                                      };
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:basicParams];
        if (_categoryId > 0) {
            [params setObject:[NSNumber numberWithInteger:_categoryId] forKey:@"category_id"];
        }
        if (_keyword) {
            [params setObject:_keyword forKey:@"keyword"];
        }
        if (_brandId > 0) {
            [params setObject:[NSNumber numberWithInteger:_brandId] forKey:@"manufacturer"];
        }
        if (_filters) {
            NSDictionary *filterParams = [_filters formatAllSelectedFilterValuesToDict];
            if (filterParams) {
                [params addEntriesFromDictionary:filterParams];
            }
        }
        
        __weak typeof(self) weakSelf = self;
        NSString *requestUrl = _keyword ? @"products/search" : @"products";
        [[Network sharedInstance] GET:requestUrl params:params callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                
                if (weakSelf.collectionView.mj_header.isRefreshing) {
                    [weakSelf.collectionView.mj_header endRefreshing];
                }
                
                if (weakSelf.collectionView.mj_footer.isRefreshing) {
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }
                
                ProductGridModel *result = [[ProductGridModel alloc] initWithDictionary:data error:nil];
                
                weakSelf.currentPage = result.currentPage;
                weakSelf.lastPage = result.lastPage;
                
                if (result.products.count > 0) {
                    if (weakSelf.refreshLoadData) {
                        weakSelf.refreshLoadData = NO;
                        [weakSelf.products removeAllObjects];
                    }
                    
                    [weakSelf.products addObjectsFromArray:result.products];
                    
                    [weakSelf.collectionView reloadData];
                } else {
                    if (weakSelf.refreshLoadData) {
                        weakSelf.refreshLoadData = NO;
                        [weakSelf.products removeAllObjects];
                        [weakSelf.collectionView reloadData];
                    }
                }
                
                if (weakSelf.products.count < 1) {
                    weakSelf.collectionView.mj_header = nil;
                    weakSelf.collectionView.mj_footer = nil;
                    
                    [weakSelf.sortStackView setHidden:YES];
                    [weakSelf.sortButtonBottomLine setHidden:YES];
                    
                    weakSelf.collectionView.backgroundView = [self emptyView];
                } else {
                    [weakSelf.sortStackView setHidden:NO];
                    [weakSelf.sortButtonBottomLine setHidden:NO];
                    
                    [weakSelf addMJRefreshHeader];
                    [weakSelf addMJRefreshFooter];
                }
                
                if (weakSelf.currentPage >= weakSelf.lastPage) {
                    weakSelf.collectionView.mj_footer = nil;
                }
                
                weakSelf.currentPage++;
                
                [weakSelf requestFilterAPI];
            }
            
            if (error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
                
                if (weakSelf.collectionView.mj_header.isRefreshing) {
                    [weakSelf.collectionView.mj_header endRefreshing];
                }
                
                if (weakSelf.collectionView.mj_footer.isRefreshing) {
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }
            }
        }];
    }
}

- (void)requestFilterAPI {
    // Get filters data only once
    if (_filters) {
        return;
    }

    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"products/filters" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            return;
        }
        
        if (data) {
            weakSelf.filters = [[FilterCollectionModel alloc] initWithDictionary:data error:nil];
            if (!weakSelf.filters) {
                return;
            }
        }
    }];
}

- (void)addMJRefreshHeader {
    if (_collectionView.mj_header == nil) {
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.showHUD = YES;
            weakSelf.collectionView.backgroundView = nil;
            weakSelf.collectionView.mj_footer = nil;
            
            weakSelf.refreshLoadData = YES;
            
            weakSelf.currentPage = 1;
            weakSelf.lastPage = weakSelf.currentPage;
            
            [weakSelf requestAPI];
        }];
    }
}

- (void)addMJRefreshFooter {
    if (_collectionView.mj_footer == nil) {
        __weak typeof(self) weakSelf = self;
        _collectionView.mj_footer = [GDRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf requestAPI];
        }];
    }
}

- (EmptyView *)emptyView {
    _currentPage = 1;
    _lastPage = _currentPage;
    
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, -200, SCREEN_WIDTH, SCREEN_HEIGHT)];
    emptyView.iconImageView.image = [UIImage imageNamed:@"empty_list"];
    emptyView.textLabel.text = NSLocalizedString(@"empty_category_no_product", nil);
    [emptyView.reloadButton addTarget:self action:@selector(requestAPI) forControlEvents:UIControlEventTouchUpInside];

    return emptyView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _products.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductGridCollectionViewCell *cell = (ProductGridCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ProductGridCollectionViewCell forIndexPath:indexPath];
    
    ProductGridItemModel *product = [_products objectAtIndex:indexPath.row];
    cell.product = product;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductGridItemModel *product = [_products objectAtIndex:indexPath.row];
    ProductViewController *nextVC = [[ProductViewController alloc] init];
    nextVC.productId = product.productId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - Actions
- (void)changeOrderType:(UIButton *)sender {
    // Default = sort_order, only has desc
    if (sender == _defaultButton) {
        _sortOrderDESC = YES;
        _sortBy = SortBySortOrder;
    } else {
        _sortOrderDESC = !_sortOrderDESC;

        if (sender == _saleButton) {
            _sortBy = SortBySales;
        } else if (sender == _priceButton) {
            _sortBy = SortByPrice;
        } else {
            _sortBy = SortByRating;
        }
    }

    [sender setImage:[UIImage imageNamed: _sortOrderDESC ? @"down": @"up"] forState:UIControlStateSelected];

    [_defaultButton setSelected: _sortBy == SortBySortOrder];
    [_saleButton setSelected:_sortBy == SortBySales];
    [_priceButton setSelected:_sortBy == SortByPrice];
    [_ratingButton setSelected:_sortBy == SortByRating];

    [_collectionView.mj_header beginRefreshing];
}

- (void)selectSearchTab {
    NSLog(@"selectSearchTab");
    SearchViewController *nextViewController = [SearchViewController new];
    nextViewController.pushedFromViewController = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)filterButtonClicked {
    if (!_filters) {
        return;
    }
    
    FilterModalView *filterModalView = [[FilterModalView alloc] init];
    filterModalView.filters = _filters;
    [filterModalView show];
    
    __weak typeof(self) weakSelf = self;
    filterModalView.submitButtonClickedBlock = ^{
        _refreshLoadData = YES;
        _currentPage = 1;
        _lastPage = _currentPage;
        [weakSelf requestAPI];
    };
}

#pragma mark - Private
- (UIButton *)makeSortButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"arrow-placeholder"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"down"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorWithHexString:@"808080" alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.backgroundColor = [UIColor whiteColor];

    button.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    button.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);

    [button addTarget:self action:@selector(changeOrderType:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (NSString *)convertSortByToString {
    switch (_sortBy) {
        case SortBySales:
            return @"sales";
        case SortByPrice:
            return @"price";
        case SortByRating:
            return @"rating";
        case SortByViewed:
            return @"viewed";
        default:
            return @"sort_order";
    }
}

@end
