//
//  CategoryAllFlatViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 26/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "CategoryAllFlatViewController.h"
#import "CategoryFirstLevelAllModel.h"
#import "CategorySecondAndThirdLevelModel.h"
#import "CategoryAllCollectionViewCell.h"
#import "CategoryViewController.h"
#import "CategoryAllCollectionReusableViewHeader.h"
#import "GDSearchUIButton.h"
#import "GDNavigationBarWithSearch.h"
#import "SearchViewController.h"
#import "CategoryAllFlatStyleFirstCell.h"
#import "GDRefreshNormalHeader.h"
#import "EmptyView.h"
#import "RDVTabBarController.h"

static CGFloat const COLLECTION_CELL_GUTTER = 6.0;
static NSInteger const COLLECTION_CELL_FLAT_STYLE_ITEMS_PER_ROW = 5;

@interface CategoryAllFlatViewController ()
@property (strong, nonatomic) CategoryFirstLevelAllModel *categoriesModel;
@property (strong, nonatomic) CategorySecondAndThirdLevelModel *subCategoriesModel;
@property (nonatomic) CGFloat collectionViewCellUILabelHeight;
@property (nonatomic) BOOL parentCategoriesLoaded;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation CategoryAllFlatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    GDSearchUIButton *searchButton;
    
    CGFloat searchBarViewWidth = self.view.frame.size.width * 0.8;
    CGFloat searchBarViewHeight = 44 * 0.7;
    CGFloat searchBarViewX = 0;
    CGFloat searchBarViewY = ((44 - searchBarViewHeight) * 0.5);
    
    searchButton = [[GDSearchUIButton alloc] initWithFrame:CGRectMake(searchBarViewX, searchBarViewY, searchBarViewWidth, searchBarViewHeight)];
    [searchButton addTarget:self action:@selector(selectSearchTab) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = searchButton;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = COLLECTION_CELL_GUTTER;
    layout.minimumInteritemSpacing = COLLECTION_CELL_GUTTER;
    layout.sectionInset = UIEdgeInsetsMake(COLLECTION_CELL_GUTTER, 0, 0, 0);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, [[System sharedInstance] tabBarHeight], 0);
    
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [_collectionView registerClass:[CategoryAllFlatStyleFirstCell class] forCellWithReuseIdentifier:kCellIdentifier_CategoryAllFlatStyleFirstCell];
    [_collectionView registerClass:[CategoryAllCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CategoryAllCollectionViewCell];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!_parentCategoriesLoaded) {
        [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (animated) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    [[Network sharedInstance] GET:@"categories?type=all" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        if (weakSelf.collectionView.mj_header.isRefreshing) {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
        
        if (data) {
            weakSelf.parentCategoriesLoaded = YES;
            weakSelf.categoriesModel = [[CategoryFirstLevelAllModel alloc] initWithDictionary:data error:nil];
            if (_categoriesModel.categories.count <= 0) {
                _collectionView.backgroundView = [self emptyView];
            } else {
                [weakSelf addMJRefreshHeader];
            }
            [_collectionView reloadData];
        }
        
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

- (void)addMJRefreshHeader {
    if (_collectionView.mj_header == nil) {
        _collectionView.mj_header = [GDRefreshNormalHeader headerWithRefreshingBlock:^{
            _collectionView.backgroundView = nil;
            [self loadData];
        }];
    }
}

- (EmptyView *)emptyView {
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:_collectionView.bounds];
    emptyView.iconImageView.image = [UIImage imageNamed:@"empty_list"];
    emptyView.textLabel.text = NSLocalizedString(@"empty_category_no_product", nil);
    [emptyView.reloadButton addTarget:self action:@selector(loadData) forControlEvents:UIControlEventTouchUpInside];
    return emptyView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _categoriesModel.categories.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CategoryFirstLevelItemModel *category = [_categoriesModel.categories objectAtIndex:section];
    return category.children.count + 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryFirstLevelItemModel *category = [_categoriesModel.categories objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        CategoryAllFlatStyleFirstCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: kCellIdentifier_CategoryAllFlatStyleFirstCell forIndexPath:indexPath];
        
        [cell setCategory:category];
        
        return cell;
    } else {
        CategoryAllCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CategoryAllCollectionViewCell forIndexPath:indexPath];
        CategoryFirstLevelItemModel *subcategory = [[CategoryFirstLevelItemModel alloc] initWithDictionary: [category.children objectAtIndex:indexPath.row - 1] error:nil];
        
        [cell setImage:subcategory.image name:subcategory.name];
        return cell;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { // First cell is the parent category, full width with big banner.
        CGFloat width = collectionView.frame.size.width;
        CGFloat height = width * 0.3;
        return CGSizeMake(width, height);
    } else {
        CGFloat width = (collectionView.frame.size.width - COLLECTION_CELL_GUTTER * (COLLECTION_CELL_FLAT_STYLE_ITEMS_PER_ROW - 1)) / COLLECTION_CELL_FLAT_STYLE_ITEMS_PER_ROW;
        CGFloat height = width + 25;
        return CGSizeMake(width, height);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Go to category vc
    NSInteger categoryId = 0;
    
    CategoryFirstLevelItemModel *category = [_categoriesModel.categories objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        categoryId = category.categoryId;
    } else {
        CategoryFirstLevelItemModel *subcategory = [[CategoryFirstLevelItemModel alloc] initWithDictionary: [category.children objectAtIndex:indexPath.row - 1] error:nil];
        categoryId = subcategory.categoryId;
    }
    
    CategoryViewController *nextVC = [[CategoryViewController alloc] init];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.categoryId = categoryId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)selectSearchTab {
    NSLog(@"selectSearchTab");
    SearchViewController *nextViewController = [[SearchViewController alloc] init];
    nextViewController.pushedFromViewController = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}

@end
