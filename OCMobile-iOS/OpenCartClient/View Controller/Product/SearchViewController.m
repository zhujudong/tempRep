//
//  SearchViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchItemCell.h"
#import "SearchTitleCell.h"
#import "CategoryViewController.h"
#import "SettingModel.h"
#import "RDVTabBarController.h"

static CGFloat const SEARCH_CELL_HEIGHT = 30.0;
static CGFloat const SEARCH_CELL_GUTTER = 10.0;
static NSInteger const SEARCH_CELLS_PER_ROW = 3;

@interface SearchViewController ()
@property (assign, nonatomic) CGFloat searchItemCellWidth;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) SettingModel *setting;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;

    if (_pushedFromViewController) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
        [backButton setImageInsets:UIEdgeInsetsMake(1., -6., 0, 0)];
        self.navigationItem.leftBarButtonItem = backButton;
    }

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [_searchBar setShowsCancelButton:YES animated:YES];

    _searchBar.delegate = self;

    for (UIView *view in [_searchBar.subviews[0] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel = (UIButton *)view;
            [cancel setTitle:NSLocalizedString(@"text_cancel", nil) forState:UIControlStateNormal];
        }
    }

    [_searchBar setPlaceholder:NSLocalizedString(@"text_search_placeholder", nil)];
    [_searchBar sizeToFit];

    self.navigationItem.titleView = _searchBar;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = SEARCH_CELL_GUTTER;
    layout.minimumInteritemSpacing = SEARCH_CELL_GUTTER;
    layout.sectionInset = UIEdgeInsetsMake(0, SEARCH_CELL_GUTTER, 0, SEARCH_CELL_GUTTER);
    _searchItemCellWidth =  floorf((self.view.frame.size.width -  (SEARCH_CELL_GUTTER * (SEARCH_CELLS_PER_ROW + 1))) / SEARCH_CELLS_PER_ROW);
    layout.itemSize = CGSizeMake(_searchItemCellWidth, SEARCH_CELL_HEIGHT);
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 50.);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [_collectionView registerClass:[SearchItemCell class] forCellWithReuseIdentifier:kCellIdentifier_SearchItemCell];
    [_collectionView registerClass:[SearchTitleCell class]
        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
               withReuseIdentifier:kCellIdentifier_SearchTitleCell];

    [self requestAPI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];

    if (_pushedFromViewController) {
        __weak id weakSelf = self;
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    [_collectionView reloadData];

    [_searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (animated) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }

    [_searchBar resignFirstResponder];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [[Network sharedInstance] GET:@"settings" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            return;
        }

        if (data) {
            weakSelf.setting = [[SettingModel alloc] initWithDictionary:data error:nil];
            if (weakSelf.setting.keywords.count) {
                [weakSelf.collectionView reloadData];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _setting.keywords.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;

    cell = [self createKeywordCell:indexPath];

    return cell;
}

- (SearchItemCell *)createKeywordCell:(NSIndexPath*)indexPath {
    SearchItemCell *cell = (SearchItemCell*)[_collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_SearchItemCell forIndexPath:indexPath];

    [cell setKeyword:[_setting.keywords objectAtIndex:indexPath.row]];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        SearchTitleCell *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdentifier_SearchTitleCell forIndexPath:indexPath];
        return reusableview;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyword = [_setting.keywords objectAtIndex:indexPath.row];

    [self goToCategoryViewControllerWithKeyword:keyword];
}

//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//  UIButton *cancelbutton = [searchBar valueForKey:@"_cancelButton"];
//  [cancelbutton setTitle:NSLocalizedString(@"text_cancel", nil) forState:UIControlStateNormal];
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];

    [self goToCategoryViewControllerWithKeyword:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];

    if (_pushedFromViewController) {
        [self popViewController];
    } else {
        [[self rdv_tabBarController] setSelectedIndex:0];
    }
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToCategoryViewControllerWithKeyword:(NSString *)keyword {
    CategoryViewController *nextVC = [CategoryViewController new];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.keyword = keyword;
    [self.navigationController pushViewController:nextVC animated:YES];
}

@end
