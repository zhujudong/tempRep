//
//  ProductViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 3/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductViewController.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "ProductNameCell.h"
#import "ProductSimpleCell.h"
#import "ProductReviewItemCell.h"
#import "ProductReviewItemModel.h"
#import "ProductReviewAllCell.h"
#import "ProductSectionTitleCell.h"
#import "ProductViewDescCell.h"
#import "ProductDetailOptionModel.h"
#import "ProductDetailOptionValueModel.h"
#import "GDUILabel.h"
#import "ProductOptionCell.h"
#import "OptionGroupNameCell.h"
#import "Customer.h"
#import "ProductDetailModel.h"
#import "ProductReviewsViewController.h"
#import "UITabBarController+CartNumber.h"
#import "CartViewController.h"
#import "LoginViewController.h"
#import "GDTopImageButton.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "ProductCarouselView.h"
#import "ProductRelatedCell.h"
#import "ProductInfoBoxCell.h"
#import "ProductOptionModalView.h"
#import "AppDelegate.h"
#import "RDVTabBarController+CartNumber.h"
#import "RDVTabBarController.h"
#import "ProductFullScreenImageViewController.h"
#import "ProductCarouselFullScreenView.h"

static CGFloat const ADD_TO_CART_BUTTON_HEIGHT = 50.0;
static CGFloat const ADD_TO_CART_BUTTON_WIDTH = 180.0;
static BOOL const STATIC_BANNER_CELL_ENABLED = YES;
static NSInteger const TABLEVIEW_TAG = 200;

// Section index
typedef NS_ENUM(NSInteger, SectionIndex) {
    SectionIndexInfo,
    SectionIndexBanner,
    SectionIndexReview,
    SectionIndexRelated,
    SectionIndexDetail,
};

// Product Info section cell index
typedef NS_ENUM(NSInteger, ProductInfoSectionCellIndex) {
    ProductInfoSectionCellIndexName,
    ProductInfoSectionCellIndexStock,
    ProductInfoSectionCellIndexViewCount,
    ProductInfoSectionCellIndexOption,
};

@interface ProductViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) ProductCarouselView *productCarouselView;
@property (strong, nonatomic) UIButton *addToCartButton;
@property (strong, nonatomic) GDTopImageButton *wishlistButton;
@property (strong, nonatomic) GDTopImageButton *cartButton;
@property (assign, nonatomic) BOOL productDescLoaded;
@property (strong, nonatomic) ProductDetailModel *product;
@property (assign, nonatomic) NSInteger selectedQuantity;
@property (strong, nonatomic) NSMutableDictionary *selectedOptions;

@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Hide back button text
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"efefef" alpha:1];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.and.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-ADD_TO_CART_BUTTON_HEIGHT);
    }];

    _addToCartButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addToCartButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    [_addToCartButton setTitle:NSLocalizedString(@"button_product_add_to_cart", nil) forState:UIControlStateNormal];
    _addToCartButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addToCartButton addTarget:self action:@selector(addToCartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _addToCartButton.enabled = NO;
    [self.view addSubview:_addToCartButton];
    [_addToCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_scrollView.mas_bottom);
        make.width.mas_equalTo(ADD_TO_CART_BUTTON_WIDTH);
        make.trailing.and.bottom.equalTo(self.view);
    }];

    _wishlistButton = [[GDTopImageButton alloc] init];
    _wishlistButton.backgroundColor = [UIColor blackColor];
    [_wishlistButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [_wishlistButton setTitle:NSLocalizedString(@"button_product_wishlist_no", nil) forState:UIControlStateNormal];
    [_wishlistButton setImage:[UIImage imageNamed:@"heart_active"] forState:UIControlStateSelected];
    [_wishlistButton setTitle:NSLocalizedString(@"button_product_wishlist_yes", nil) forState:UIControlStateSelected];
    _wishlistButton.titleLabel.font = [UIFont systemFontOfSize:9];
    _wishlistButton.spacing = 3;
    [_wishlistButton addTarget:self action:@selector(wishlistButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _wishlistButton.enabled = NO;
    [self.view addSubview:_wishlistButton];

    _cartButton = [[GDTopImageButton alloc] init];
    _cartButton.backgroundColor = [UIColor blackColor];
    [_cartButton setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [_cartButton setTitle:NSLocalizedString(@"button_product_cart", nil) forState:UIControlStateNormal];
    _cartButton.titleLabel.font = [UIFont systemFontOfSize:9];
    _cartButton.spacing = 3;
    [_cartButton addTarget:self action:@selector(cartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cartButton];

    [_wishlistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.bottom.equalTo(self.view);
        make.top.equalTo(_addToCartButton.mas_top);
        make.width.mas_equalTo(_cartButton.mas_width);
    }];

    [_cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_wishlistButton.mas_trailing);
        make.trailing.equalTo(_addToCartButton.mas_leading);
        make.top.equalTo(_addToCartButton.mas_top);
        make.bottom.equalTo(self.view);
        make.width.mas_equalTo(_wishlistButton.mas_width);
    }];

    //init some values
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1.];
    _tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1.];
    _tableView.tag = TABLEVIEW_TAG;
    _tableView.contentInset = UIEdgeInsetsMake(SCREEN_WIDTH, 0, 0, 0); // Inset for image carousel view on top
    [_tableView registerClass:[ProductNameCell class] forCellReuseIdentifier:kCellIdentifier_ProductNameCell];
    [_tableView registerClass:[ProductSimpleCell class] forCellReuseIdentifier:kCellIdentifier_ProductSimpleCell];
    [_tableView registerClass:[ProductSectionTitleCell class] forCellReuseIdentifier:kCellIdentifier_ProductSectionTitleCell];
    [_tableView registerClass:[ProductReviewItemCell class] forCellReuseIdentifier:kCellIdentifiler_ProductReviewItemCell];
    [_tableView registerClass:[ProductReviewAllCell class] forCellReuseIdentifier:kCellIdentifier_ProductReviewAllCell];
    [_tableView registerClass:[ProductRelatedCell class] forCellReuseIdentifier:kCellIdentifier_ProductRelatedCell];
    [_tableView registerClass:[ProductViewDescCell class] forCellReuseIdentifier:kCellIdentifier_ProductViewDescCell];
    [_tableView registerClass:[ProductInfoBoxCell class] forCellReuseIdentifier:kCellIdentifier_ProductInfoBoxCell];
    [_scrollView addSubview:_tableView];

    _tableView.estimatedRowHeight = 100.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;

    __weak typeof(self) weakSelf = self;
    _productCarouselView = [[ProductCarouselView alloc] initWithFrame:CGRectMake(0, -SCREEN_WIDTH, SCREEN_WIDTH, SCREEN_WIDTH)];
    _productCarouselView.fullScreenImagesBlock = ^{
        [weakSelf showFullScreenImages];
    };
    [_tableView addSubview:_productCarouselView];

    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.backgroundColor = [UIColor whiteColor];

    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.webView.scrollView.mj_header endRefreshing];
        }];
    }];

    [refreshHeader setTitle:NSLocalizedString(@"text_back_to_product_detail_state_idle", nil) forState:MJRefreshStateIdle];
    [refreshHeader setTitle:NSLocalizedString(@"text_back_to_product_detail_state_pulling", nil) forState:MJRefreshStatePulling];
    [refreshHeader setTitle:NSLocalizedString(@"text_back_to_product_detail_state_refreshing", nil) forState:MJRefreshStateRefreshing];

    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.activityIndicatorViewStyle = NO;

    _webView.scrollView.mj_header = refreshHeader;
    _webView.scrollView.delaysContentTouches = NO;

    [_scrollView addSubview:_webView];

    // Share button
    if (CONFIG_PRODUCT_SHARE_ENABLED) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"product_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, (_scrollView.frame.size.height) * 2);
    _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height);
    _webView.frame = CGRectMake(0, _scrollView.frame.size.height, SCREEN_WIDTH, _scrollView.frame.size.height);
    
    [self updateCartButtonNumber];

    if (!_product) {
        [self requestAPI];
    }
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [[Network sharedInstance] GET:[NSString stringWithFormat:@"products/%ld?width=%d&height=%d", (long)_productId, (int)SCREEN_WIDTH * 2, (int)SCREEN_WIDTH * 2] params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            weakSelf.product = [[ProductDetailModel alloc] initWithDictionary:data error:nil];
            if (weakSelf.product) {
                [weakSelf updateUI];
                return;
            }
        }

        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"empty_category_no_product", nil)];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_product == nil) {
        return 0;
    }

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionIndexInfo:
            return 4; // name + stock + view count + option
        case SectionIndexBanner:
            return STATIC_BANNER_CELL_ENABLED == YES ? 1 : 0;
        case SectionIndexReview:
            if (_product.reviews.count) {
                return _product.reviews.count + 2;
            }
            return 2;
        case SectionIndexRelated:
            if (_product.relatedProducts.count) {
                return 2; // A header cell + collection view cell
            }
            return 0; // No related products
        case SectionIndexDetail: { // Pull up to detail section
            return 1;
        }
    }

    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == SectionIndexInfo) {
        if (row == ProductInfoSectionCellIndexName) {
            ProductNameCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductNameCell];
            cell.product = _product;
            return cell;
        }

        if (row == ProductInfoSectionCellIndexStock) {
            return  [self tableView:tableView createProductSimpleCellWithTitle:NSLocalizedString(@"text_stock", nil) text:[NSString stringWithFormat:NSLocalizedString(@"text_stock_number", nil), _product.quantity] accessoryType:UITableViewCellAccessoryNone];
        }

        if (row == ProductInfoSectionCellIndexViewCount) {
            return [self tableView:tableView createProductSimpleCellWithTitle:NSLocalizedString(@"text_views", nil) text:[NSString stringWithFormat:NSLocalizedString(@"text_view_number", nil), _product.viewed + 12] accessoryType:UITableViewCellAccessoryNone];
        }

        if (row == ProductInfoSectionCellIndexOption) {
            return [self tableView:tableView createProductSimpleCellWithTitle:NSLocalizedString(@"text_options", nil) text:[_product textForOptionCell] accessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }

    if (section == SectionIndexBanner) {
        return [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductInfoBoxCell forIndexPath:indexPath];
    }

    if (section == SectionIndexReview) {
        // Title cell
        if (row == 0) {
            ProductSectionTitleCell *cell = [self tableView:tableView createProductSectionTitleCell:NSLocalizedString(@"label_cell_product_review_title", nil)];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;
        }

        // Review content cell
        row--;
        if (_product.reviews.count && row < _product.reviews.count) {
            ProductReviewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifiler_ProductReviewItemCell];
            [cell setReview:[_product.reviews objectAtIndex:row]];
            return cell;
        }

        // All review button cell
        return [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductReviewAllCell];
    }

    if (section == SectionIndexRelated) {
        if (row == 0) {
            return [self tableView:tableView createProductSectionTitleCell:NSLocalizedString(@"text_related_products", nil)];
        }

        ProductRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductRelatedCell];
        __weak typeof(self) weakSelf = self;
        [cell setProducts:_product.relatedProducts];
        cell.relatedProductClickedBlock = ^(NSInteger productId) {
            ProductViewController *nextVC = [[ProductViewController alloc] init];
            nextVC.productId = productId;
            [weakSelf.navigationController pushViewController:nextVC animated:YES];
        };
        return cell;
    }

    if (section == SectionIndexDetail) {
        ProductViewDescCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductViewDescCell];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Static banner cell is disabled
    if (section == SectionIndexBanner && STATIC_BANNER_CELL_ENABLED == NO) {
        return 0.01;
    }
    
    // No related products
    if (section == SectionIndexRelated && _product.relatedProducts.count < 1) {
        return 0.01;
    }
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Option modal
    if (indexPath.section == SectionIndexInfo && indexPath.row == ProductInfoSectionCellIndexOption) {
        [self addToCartButtonClicked];
    }

    if (indexPath.section == SectionIndexReview) {
        [self allReviewsButtonClicked];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == TABLEVIEW_TAG) {
        CGFloat offsetY = scrollView.contentOffset.y;
        //NSLog(@"scrollView Y: %f", offsetY);
        if (offsetY < -SCREEN_WIDTH - 10) {
            //return;
        }

        [_productCarouselView setOffsetY: (-SCREEN_WIDTH - offsetY) * -0.5];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // pull up webview
    if (scrollView.tag == TABLEVIEW_TAG) {
        if (scrollView.contentOffset.y >= _tableView.contentSize.height - scrollView.frame.size.height + 40) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(0, weakSelf.scrollView.frame.size.height);
            } completion:^(BOOL finished) {
                if (!weakSelf.productDescLoaded) {
                    NSString *url = [NSString stringWithFormat:@"%@index.php?route=app/product/description&product_id=%ld&lang=%@", CONFIG_WEB_URL, (long)weakSelf.productId, [[System sharedInstance] languageCode]];
                    NSLog(@"%@", url);

                    [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                    weakSelf.productDescLoaded = YES;
                }
            }];
        }
    }
}

#pragma mark - Custom cell
- (ProductSimpleCell *)tableView:(UITableView *)tableView createProductSimpleCellWithTitle:(NSString*)title text:(NSString*)text accessoryType:(UITableViewCellAccessoryType)accessoryType {
    ProductSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductSimpleCell];
    [cell setTextForKey:title withValue:text];
    cell.accessoryType = accessoryType;
    return cell;
}

- (ProductSectionTitleCell *)tableView:(UITableView *)tableView createProductSectionTitleCell:(NSString *)text {
    ProductSectionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ProductSectionTitleCell];
    cell.title = text;
    return cell;
}

#pragma mark - Actions
- (void)allReviewsButtonClicked {
    ProductReviewsViewController *nextVC = [ProductReviewsViewController new];
    nextVC.productId = _productId;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)cartButtonClicked {
    CartViewController *nextVC = [[CartViewController alloc] init];
    nextVC.hideTabBar = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)addToCartButtonClicked {
    __weak typeof(self) weakSelf = self;

    ProductOptionModalView *modalView = [[ProductOptionModalView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:modalView];
    [modalView setProduct:_product];

    modalView.productOptionModalClosedBlock = ^(BOOL shouldReloadProductTableView) {
        if (shouldReloadProductTableView) {
            [weakSelf updateUI];
        }
    };
    [modalView show];
}

- (void)wishlistButtonClicked {
    if (![[Customer sharedInstance] isLogged]) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) presentLoginViewController];
        return;
    }
    __weak typeof(self) weakSelf = self;

    if (_product.addedWishlist == NO) { // Add to wishlist
        NSDictionary *params = @{@"product_id": [NSNumber numberWithInteger:_productId]};
        [[Network sharedInstance] POST:@"wishlist" params:params callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                weakSelf.product.addedWishlist = YES;
                [weakSelf.wishlistButton setSelected:weakSelf.product.addedWishlist];
            }

            if (error) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    } else { // Remove from wishlist
        [[Network sharedInstance] DELETE:[NSString stringWithFormat:@"wishlist/%ld", (long)_productId] params:nil callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                weakSelf.product.addedWishlist = NO;
                [weakSelf.wishlistButton setSelected:weakSelf.product.addedWishlist];
            }

            if (error) {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
            }
        }];
    }
}

- (void)shareButtonClicked {
    if (_product == nil) {
        return;
    }

    if (_product.image.length < 1) {
        return;
    }

    NSArray *images = @[_product.image];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:_product.name
                                images:images
                                   url:[NSURL URLWithString:_product.trackingUrl]
                                 title:_product.name
                                  type:SSDKContentTypeAuto];
    
    __weak typeof(self) weakSelf = self;

    [SSUIShareActionSheetStyle defaultSheetStyle];
    UIBarButtonItem * rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    UIView *view = [rightBarButtonItem valueForKey:@"view"];
    [ShareSDK showShareActionSheet:view customItems:nil shareParams:params sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess: {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_share_success", nil)];
                break;
            }
            case SSDKResponseStateFail: {
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_share_failed", nil)];
                break;
            }
            default:
                [MBProgressHUD showToastToView:weakSelf.view withMessage:NSLocalizedString(@"toast_share_failed", nil)];
                break;
        }
    }];
}

- (void)showFullScreenImages {
    ProductFullScreenImageViewController *fullScreenVC = [[ProductFullScreenImageViewController alloc] init];
    fullScreenVC.images = [_product allImages];
    fullScreenVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:fullScreenVC animated:YES completion:nil];
}

#pragma mark - private
- (void)updateUI {
    _productCarouselView.product = _product;
    [_tableView reloadData];
    [_wishlistButton setSelected:_product.addedWishlist];
    _wishlistButton.enabled = YES;

    _addToCartButton.enabled = YES;
    if (_product.quantity < 1) {
        [_addToCartButton setTitle:NSLocalizedString(@"button_product_add_to_cart_out_of_stock", nil) forState:UIControlStateDisabled];
        _addToCartButton.backgroundColor = [UIColor lightGrayColor];
    }

    [self updateOptionCellText];
    [self updateCartButtonNumber];
}

- (void)updateCartButtonNumber {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView *subView in weakSelf.cartButton.subviews) {
                if (subView.tag == 100) {
                    [subView removeFromSuperview];
                }
            }

            if ([[Customer sharedInstance] cartNumber] < 1) {
                return;
            }

            CGFloat textPadding = 3.;

            //Background
            UIView *numberBackground = [[UIView alloc] initWithFrame:CGRectZero];
            numberBackground.tag = 100;
            numberBackground.backgroundColor = CONFIG_PRIMARY_COLOR;
            numberBackground.layer.cornerRadius = 5.;
            numberBackground.clipsToBounds = YES;

            //Label
            UILabel *numberLabel = [[UILabel alloc] init];
            numberLabel.text = [NSString stringWithFormat:@"%ld", (long)[[Customer sharedInstance] cartNumber]];
            numberLabel.font = [UIFont systemFontOfSize:9.];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [numberLabel sizeToFit];

            numberLabel.frame = CGRectMake(textPadding, 0, MAX(numberLabel.frame.size.width, 10.), numberLabel.frame.size.height);
            [numberBackground addSubview:numberLabel];

            //Position
            CGFloat x = ceilf(_cartButton.frame.size.width * .5 + 5.);
            CGFloat y = ceilf(0.1 * _cartButton.frame.size.height);
            numberBackground.frame = CGRectMake(x, y, numberLabel.frame.size.width + textPadding * 2, numberLabel.frame.size.height);

            [weakSelf.cartButton addSubview:numberBackground];
        });
    });
}

-(void)updateOptionCellText {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:ProductInfoSectionCellIndexOption inSection:SectionIndexInfo];
    ProductSimpleCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    [cell setTextForKey:cell.keyLabel.text withValue:[_product textForOptionCell]];
}
@end
