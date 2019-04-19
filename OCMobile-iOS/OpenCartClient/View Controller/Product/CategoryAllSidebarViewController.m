//
//  CategoryAllSidebarViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "CategoryAllSidebarViewController.h"
#import "CategoryListTableViewCell.h"
#import "CategoryAllCollectionViewCell.h"
#import "CategoryViewController.h"
#import "CategoryAllCollectionReusableViewHeader.h"
#import "GDSearchUIButton.h"
#import "GDNavigationBarWithSearch.h"
#import "SearchViewController.h"
#import "RDVTabBarController.h"

static CGFloat const COLLECTION_CELL_GUTTER = 6.0;
static NSInteger const COLLECTION_CELL_SIDEBAR_STYLE_ITEMS_PER_ROW = 3;

@interface CategoryAllSidebarViewController ()
@property (strong, nonatomic) CategoryFirstLevelAllModel *categoriesModel;
@property (strong, nonatomic) CategorySecondAndThirdLevelModel *subCategoriesModel;
@property (nonatomic) CGFloat collectionViewCellUILabelHeight;
@property (nonatomic) BOOL parentCategoriesLoaded;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation CategoryAllSidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    GDSearchUIButton *searchButton;
    
    CGFloat searchBarViewWidth = self.view.frame.size.width * 0.8;
    CGFloat searchBarViewHeight = 44 * 0.7;
    CGFloat searchBarViewX = 0;
    CGFloat searchBarViewY = ((44 - searchBarViewHeight) * 0.5);
    
    searchButton = [[GDSearchUIButton alloc] initWithFrame:CGRectMake(searchBarViewX, searchBarViewY, searchBarViewWidth, searchBarViewHeight)];
    [searchButton addTarget:self action:@selector(selectSearchTab) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = searchButton;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"F3F4F6" alpha:1];
    _tableView.separatorColor = [UIColor colorWithHexString:@"E5E5E5" alpha:1];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, [[System sharedInstance] tabBarHeight], 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 100.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [_tableView registerClass:[CategoryListTableViewCell class] forCellReuseIdentifier:kCellIdentifier_CategoryListTableViewCell];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.and.bottom.equalTo(self.view);
        make.width.mas_equalTo(100);
    }];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = COLLECTION_CELL_GUTTER;
    layout.minimumInteritemSpacing = COLLECTION_CELL_GUTTER;
    layout.sectionInset = UIEdgeInsetsMake(COLLECTION_CELL_GUTTER, 0, COLLECTION_CELL_GUTTER * 2, 0);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, [[System sharedInstance] tabBarHeight], 0);
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.leading.equalTo(_tableView.mas_trailing).offset(COLLECTION_CELL_GUTTER);
        make.bottom.equalTo(self.view.mas_bottom);
        make.trailing.equalTo(self.view.mas_trailing);
    }];
    
    [_collectionView registerClass:[CategoryAllCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CategoryAllCollectionViewCell];
    [_collectionView registerClass:[CategoryAllCollectionReusableViewHeader class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:kCellIdentifier_CategoryAllCollectionReusableViewHeader];
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
    
    [[Network sharedInstance] GET:@"categories?type=top" params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];

        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }
        
        if (data) {
            weakSelf.parentCategoriesLoaded = YES;
            weakSelf.categoriesModel = [[CategoryFirstLevelAllModel alloc] initWithDictionary:data error:nil];
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.categoriesModel.categories.count) {
                [weakSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
                CategoryFirstLevelItemModel *firstCategory = [weakSelf.categoriesModel.categories objectAtIndex:0];
                [weakSelf loadSubCategories: firstCategory.categoryId];
            }
        }
    }];
}

-(void) loadSubCategories:(NSInteger)categoryId {
    _subCategoriesModel = nil;
    [self.collectionView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    
    [[Network sharedInstance] GET:[NSString stringWithFormat:@"categories/%ld", (long)categoryId] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            weakSelf.subCategoriesModel = [[CategorySecondAndThirdLevelModel alloc] initWithDictionary:data error:nil];
            
            [weakSelf.collectionView reloadData];
        }
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categoriesModel == nil ? 0 : 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoriesModel.categories.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier_CategoryListTableViewCell forIndexPath:indexPath];
    
    CategoryFirstLevelItemModel *category = [_categoriesModel.categories objectAtIndex:indexPath.row];
    
    [cell setCategory:category];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    CategoryFirstLevelItemModel *selectedCategory = [_categoriesModel.categories objectAtIndex:indexPath.row];
    NSLog(@"selected category: %ld", (long)selectedCategory.categoryId);
    [self loadSubCategories: selectedCategory.categoryId];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

#pragma mark - CollectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_subCategoriesModel == nil) {
        return 0;
    }
    
    return _subCategoriesModel.children.count ? _subCategoriesModel.children.count : 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_subCategoriesModel.children.count) {
        CategorySecondLevelItemModel *secondLevelItems = [_subCategoriesModel.children objectAtIndex:section];
        return secondLevelItems.children.count + 1;
    }
    
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryAllCollectionViewCell *cell = (CategoryAllCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_CategoryAllCollectionViewCell forIndexPath:indexPath];
    
    if (_subCategoriesModel.children.count) {
        CategorySecondLevelItemModel *secondLevelItems = [_subCategoriesModel.children objectAtIndex:indexPath.section];
        
        if (indexPath.row < secondLevelItems.children.count) {
            CategoryFirstLevelItemModel *categoryModel = [secondLevelItems.children objectAtIndex:indexPath.row];
            [cell setImage:categoryModel.image name:categoryModel.name];
        } else {
            [cell setImage:secondLevelItems.image name:NSLocalizedString(@"text_all", nil)];
        }
    } else {
        [cell setImage:_subCategoriesModel.image name:NSLocalizedString(@"text_all", nil)];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.frame.size.width - COLLECTION_CELL_GUTTER * (COLLECTION_CELL_SIDEBAR_STYLE_ITEMS_PER_ROW - 1)) / COLLECTION_CELL_SIDEBAR_STYLE_ITEMS_PER_ROW;
    CGFloat height = width + 25;
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Go to category vc
    NSInteger categoryId = 0;
    
    if (_subCategoriesModel.children.count) {
        CategorySecondLevelItemModel *secondLevelItems = [_subCategoriesModel.children objectAtIndex:indexPath.section];
        
        if (indexPath.row < secondLevelItems.children.count) {
            CategoryFirstLevelItemModel *categoryModel = [secondLevelItems.children objectAtIndex:indexPath.row];
            categoryId = categoryModel.categoryId;
        } else {
            categoryId = secondLevelItems.categoryId;
        }
    } else {
        categoryId = _subCategoriesModel.categoryId;
    }
    
    CategoryViewController *nextVC = [[CategoryViewController alloc] init];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.categoryId = categoryId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        CategoryAllCollectionReusableViewHeader *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdentifier_CategoryAllCollectionReusableViewHeader forIndexPath:indexPath];
        
        if (_subCategoriesModel.children.count) {
            CategorySecondLevelItemModel *secondLevelItems = [_subCategoriesModel.children objectAtIndex:indexPath.section];
            
            reusableview.nameLabel.text = secondLevelItems.name;
        } else {
            reusableview.nameLabel.text = _subCategoriesModel.name;
        }
        
        return reusableview;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(self.collectionView.bounds.size.width, 30);
    return headerSize;
}

- (void)selectSearchTab {
    NSLog(@"selectSearchTab");
    SearchViewController *nextViewController = [[SearchViewController alloc] init];
    nextViewController.pushedFromViewController = YES;
    [self.navigationController pushViewController:nextViewController animated:YES];
}
@end
