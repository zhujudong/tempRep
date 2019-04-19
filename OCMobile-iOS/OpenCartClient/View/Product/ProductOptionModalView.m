//
//  ProductOptionModalView.m
//  OpenCartClient
//
//  Created by Sam Chen on 05/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "ProductOptionModalView.h"
#import "UIQuantityControl.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "OptionGroupNameCell.h"
#import "ProductOptionCell.h"
#import "ProductDetailOptionPriceModel.h"
#import "Customer.h"

static CGFloat const OPTIONAL_MODAL_THUMBNAIL_WIDTH = 80.0;
static CGFloat const OPTIONAL_MODAL_CONFIRM_BUTTON_HEIGHT = 50.0;
static CGFloat const OPTIONAL_MODAL_QTY_CONTROL_HEIGHT = 33.0;
static CGFloat const OPTIONAL_MODAL_QTY_CONTROL_WIDTH = 96.0;
static CGFloat const OPTIONAL_MODAL_COLLECTION_CELL_INSET = 10.0;

@interface ProductOptionModalView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout, UIQuantityControlDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *maskView, *modalView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel, *priceLabel, *quantityLabel, *minimumLabel, *optionLabel;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIQuantityControl *quantityControl;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) CGFloat modalViewY;
@property (strong, nonatomic) UITapGestureRecognizer *dismissRecognizer;
@property (assign, nonatomic) BOOL shouldReloadProductTableView;
@property (strong, nonatomic) NSMutableArray<ProductDetailModel> *products;
@property (strong, nonatomic) NSMutableArray *loadedProductIds;
@end

@implementation ProductOptionModalView

#pragma mark - Init views
- (id)initWithFrame:(CGRect)frame {
    if (CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }

    self = [super initWithFrame:frame];

    if (self) {
        if (!_window) {
            _window = UIApplication.sharedApplication.keyWindow;
        }
    }

    return self;
}

- (void)createMaskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.7];
        _maskView.alpha = 0.0;

        _dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _dismissRecognizer.numberOfTapsRequired = 1;
        [_maskView addGestureRecognizer:_dismissRecognizer];
        [_window addSubview:_maskView];
    }
}

- (void)createModalView {
    if (!_modalView) {
        CGFloat modalViewHeight = 0;
        if (![_product hasProductOptionOrVariant]) {
            modalViewHeight = OPTIONAL_MODAL_CONFIRM_BUTTON_HEIGHT + OPTIONAL_MODAL_QTY_CONTROL_HEIGHT + 80.0f;
        } else {
            modalViewHeight = SCREEN_HEIGHT * 0.55;
        }

        _modalViewY = SCREEN_HEIGHT - modalViewHeight;

        _modalView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, modalViewHeight)];
        _modalView.backgroundColor = [UIColor whiteColor];
        [_window addSubview:_modalView];
    }

    // Thumbnail image on top left corner
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = 6;
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderColor = CONFIG_GENERAL_BG_COLOR.CGColor;
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.layer.borderWidth = 0.5;
        if (_product.image.length) {
            [_imageView lazyLoad:_product.image];
        } else {
            _imageView.image = [UIImage imageNamed:@"placeholder"];
        }

        [_modalView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(OPTIONAL_MODAL_THUMBNAIL_WIDTH, OPTIONAL_MODAL_THUMBNAIL_WIDTH));
            make.leading.equalTo(_modalView).offset(10);
            make.top.equalTo(_modalView).offset(-OPTIONAL_MODAL_THUMBNAIL_WIDTH / 2);
        }];
    }
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.numberOfLines = 0;
        _nameLabel.text = _product.name;
        [_modalView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_imageView.mas_trailing).offset(20);
            make.trailing.equalTo(_modalView).offset(-20);
            make.top.equalTo(_modalView).offset(10);
        }];
    }

    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
        _priceLabel.textColor = CONFIG_PRIMARY_COLOR;
        _priceLabel.text = _product.special ? _product.specialFormat : _product.priceFormat;

        [_modalView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(6);
        }];
    }

    // Confirm button
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_confirmButton setTitle:NSLocalizedString(@"text_add_to_cart", nil) forState:UIControlStateNormal];
        [_confirmButton setTitle:@"暂无库存" forState:UIControlStateDisabled];
        [_confirmButton addTarget:self action:@selector(addToCartButtonClicked) forControlEvents:UIControlEventTouchUpInside];

        [_modalView addSubview:_confirmButton];
        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.and.trailing.equalTo(_modalView);
            make.height.mas_equalTo(OPTIONAL_MODAL_CONFIRM_BUTTON_HEIGHT);
        }];
    }

    // Quantity label
    if (!_quantityLabel) {
        _quantityLabel = [UILabel new];
        _quantityLabel.text = NSLocalizedString(@"text_quantity", nil);
        _quantityLabel.font = [UIFont systemFontOfSize:14.];
        _quantityLabel.textColor = [UIColor colorWithHexString:@"333333" alpha:1.0];

        [_modalView addSubview:_quantityLabel];
        [_quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_modalView).offset(10);
            make.bottom.equalTo(_confirmButton.mas_top).offset(-20);
        }];
    }

    // Minimum label
    if (!_minimumLabel && _product.minimum > 1) {
        _minimumLabel = [UILabel new];
        _minimumLabel.text = [NSString stringWithFormat:NSLocalizedString(@"text_minimum_qty", nil), _product.minimum];
        _minimumLabel.font = [UIFont systemFontOfSize:12];
        _minimumLabel.textColor = [UIColor colorWithHexString:@"C8C7CC" alpha:1.0];

        [_modalView addSubview:_minimumLabel];
        [_minimumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_quantityLabel.mas_trailing).offset(10);
            make.centerY.equalTo(_quantityLabel);
        }];
    }

    // Quantity control
    if (!_quantityControl) {
        _quantityControl = [[UIQuantityControl alloc] init];
        _quantityControl.delegate = self;
        _quantityControl.minimum = _product.minimum > 0 ? _product.minimum : 1;
        _quantityControl.quantity = [_product selectedQuantity];
        [_modalView addSubview:_quantityControl];
        [_quantityControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(OPTIONAL_MODAL_QTY_CONTROL_WIDTH, OPTIONAL_MODAL_QTY_CONTROL_HEIGHT));
            make.trailing.equalTo(_modalView).offset(-20);
            make.centerY.equalTo(_quantityLabel);
        }];
    }

    // Option collection view
    if ([_product hasProductOptionOrVariant]) {
        if(!_collectionView) {
            UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;

            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.alwaysBounceVertical = YES;
            _collectionView.contentInset = UIEdgeInsetsMake(0, OPTIONAL_MODAL_COLLECTION_CELL_INSET, 0, OPTIONAL_MODAL_COLLECTION_CELL_INSET);
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            [_collectionView registerClass:[OptionGroupNameCell class]
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader
                       withReuseIdentifier:kCellIdentifier_OptionGroupNameCell];
            [_collectionView registerClass:[ProductOptionCell class] forCellWithReuseIdentifier:kCellIdentifier_ProductOptionCell];

            [_modalView addSubview:_collectionView];
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_priceLabel.mas_bottom).offset(6);
                make.leading.and.trailing.equalTo(_modalView);
                make.bottom.equalTo(_quantityControl.mas_top).offset(-10);
            }];
        }

        [_collectionView reloadData];
    }
}

- (void)setProduct:(ProductDetailModel *)product {
    _product = product;
    if (!_products) {
        _products = [[NSMutableArray<ProductDetailModel> alloc] initWithObjects:[_product copy], nil];
    }
    
    if (!_loadedProductIds) {
        _loadedProductIds = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInteger:_product.productId], nil];
    }
}

#pragma mark - Show/dismiss action
- (void)show {
    [self createMaskView];
    [self createModalView];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _maskView.alpha = 1.0;
        CGRect modalViewFrame = _modalView.frame;
        modalViewFrame.origin.y = _modalViewY;
        _modalView.frame = modalViewFrame;
    } completion:^(BOOL finished) {
        [self updateConfirmButtonState];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        _maskView.alpha = 0.0;
        CGRect modalViewFrame = _modalView.frame;
        modalViewFrame.origin.y = SCREEN_HEIGHT + (OPTIONAL_MODAL_THUMBNAIL_WIDTH / 2);
        _modalView.frame = modalViewFrame;

    } completion:^(BOOL finished) {
        if (_productOptionModalClosedBlock) {
            _productOptionModalClosedBlock(_shouldReloadProductTableView);
        }

        [_maskView removeFromSuperview];
        [_modalView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)addToCartButtonClicked {
    [MBProgressHUD showLoadingHUDToView:_modalView];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:_product.productId] forKey:@"product_id"];
    [params setObject:[NSNumber numberWithInteger:[_product selectedQuantity]] forKey:@"quantity"];

    NSString *selectedOptionStringified = [_product stringifySelectedOptionValues];
    if (selectedOptionStringified) {
        [params setObject:selectedOptionStringified forKey:@"option"];
    }
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:@"carts" params:params callback:^(NSDictionary *data, NSString *error) {
        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.modalView animated:NO];
            [MBProgressHUD showToastToView:weakSelf.modalView withMessage:error];
            return;
        }

        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.modalView animated:NO];
            [MBProgressHUD showToastToView:weakSelf.window withMessage:NSLocalizedString(@"text_added_to_cart", nil)];
            [[Customer sharedInstance] addCartNumberBy:[_product selectedQuantity]];
            weakSelf.shouldReloadProductTableView = YES;
            [weakSelf dismiss];
        }
    }];
}

#pragma mark - CollectionView Protocol
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_product totalOptionsAndVariantGroups];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_product numberOfItemsInOptionOrVariantGroup:section];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isInVariantSectionForIndexPath:indexPath]) {
        VariantValueModel *variantValue = [_product variantValueAtIndexPath:indexPath];
        return [self createProductVariantCellForCollectionView:collectionView variantValue:variantValue indexPath:indexPath];
    }

    NSInteger section = indexPath.section - _product.variant.variants.count;
    ProductDetailOptionModel *option = [_product.options objectAtIndex:section];
    ProductDetailOptionValueModel *optionValue = [option.productOptionValue objectAtIndex:indexPath.row];
    return [self createProductOptionCellForCollectionView:collectionView option:option optionValue:optionValue indexPath:indexPath];
}

-(ProductOptionCell*)createProductVariantCellForCollectionView:(UICollectionView*)collectionView variantValue:(VariantValueModel *)variantValue indexPath:(NSIndexPath*)indexPath {
    ProductOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ProductOptionCell forIndexPath:indexPath];
    cell.text = variantValue.name;
    if ([_product.variant isVariantValueSelectedForKey:variantValue.key]) {
        [cell setButtonState:ButtonStateActive];
    } else if ([_product.variant isVariantValueSelectableForKey:variantValue.key]) {
        [cell setButtonState:ButtonStateNormal];
    } else {
        [cell setButtonState:ButtonStateDisabled];
    }
    
    return cell;
}

-(ProductOptionCell*)createProductOptionCellForCollectionView:(UICollectionView*)collectionView option:(ProductDetailOptionModel*)option optionValue:(ProductDetailOptionValueModel*)optionValue indexPath:(NSIndexPath*)indexPath {
    ProductOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ProductOptionCell forIndexPath:indexPath];
    cell.text = optionValue.name;
    if ([_product isOptionValueSelected:optionValue forOption:option]) {
        [cell setButtonState:ButtonStateActive];
    } else {
        [cell setButtonState:ButtonStateNormal];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isInVariantSectionForIndexPath:indexPath]) {
        return [ProductOptionCell buttonSize:[_product variantValueAtIndexPath:indexPath].name];
    }

    NSInteger section = indexPath.section - _product.variant.variants.count;
    ProductDetailOptionModel *option = [_product.options objectAtIndex:section];
    ProductDetailOptionValueModel *optionValue = [option.productOptionValue objectAtIndex:indexPath.row];
    return [ProductOptionCell buttonSize:optionValue.name];
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        OptionGroupNameCell *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellIdentifier_OptionGroupNameCell forIndexPath:indexPath];

        if ([self isInVariantSectionForIndexPath:indexPath]) {
            view.optionNameLabel.text = [_product.variant variantAtIndex:indexPath.section].name;
            return view;
        }

        NSInteger section = indexPath.section - _product.variant.variants.count;
        ProductDetailOptionModel *option = [_product.options objectAtIndex:section];

        // Add * after required option
        if (option.required) {
            view.optionNameLabel.text = [NSString stringWithFormat:@"%@*", option.name];
        } else {
            view.optionNameLabel.text = option.name;
        }

        return view;
    }

    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 40.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isInVariantSectionForIndexPath:indexPath]) {
        NSString *key = [_product.variant variantValueAtIndexPath:indexPath].key;

        // Disabled
        if (![_product.variant isVariantValueSelectableForKey:key]) {
            return;
        }
        
        // Unselect
        if ([_product.variant isVariantValueSelectedForKey:key]) {
            [_product.variant toggleVariantValueSelectionForKey:key];
            [self.collectionView reloadData];
            _product.quantity = 0;
            [self updateConfirmButtonState];
            return;
        }
        
        // Unselect old value
        for (VariantValueModel *value in [_product.variant variantAtIndex:indexPath.section].values) {
            if ([_product.variant isVariantValueSelectedForKey:value.key]) {
                [_product.variant toggleVariantValueSelectionForKey:value.key];
            }
        }
        
        // Select new value
        [_product.variant toggleVariantValueSelectionForKey:key];
        [self.collectionView reloadData];
        if ([_product.variant isSKUChanged]) {
            [self reloadNewProduct:[_product.variant selectedSKUProductId]];
        } else {
            // All variant selected, should make self selected
            if (_product.productId == [_product.variant selectedSKUProductId]) {
                 [self reloadNewProduct:_product.productId];
            }
        }
        return;
    }
    
    NSInteger section = indexPath.section - _product.variant.variants.count;
    [_product toggleOptionSelectionAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:section]];
    [self.collectionView reloadData];
}

#pragma mark - Quantity Control delegate
- (void)quantityChangedTo:(NSInteger)number tag:(NSUInteger)tag {
    [_product setSelectedQuantity:number];
}

#pragma mark - private
/// Check if the indexPath is in variants range
- (BOOL)isInVariantSectionForIndexPath:(NSIndexPath *)indexPath {
    if (_product.variant.variants.count && indexPath.section < _product.variant.variants.count) {
        return YES;
    }
    return NO;
}

- (void)reloadNewProduct:(NSInteger)productId {
    if (productId < 1) {
        return;
    }
    
    for (NSInteger i = 0; i < _loadedProductIds.count; i++) {
        NSNumber *loadedProductId = [_loadedProductIds objectAtIndex:i];
        if (loadedProductId.integerValue != productId) {
            continue;
        }
        
        [self switchToNewProduct:[[_products objectAtIndex:i] copy]];
        [self.collectionView reloadData];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:_modalView];
    [[Network sharedInstance] GET:[NSString stringWithFormat:@"products/%ld?width=%d&height=%d", (long)productId, (int)SCREEN_WIDTH * 2, (int)SCREEN_WIDTH * 2] params:nil callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.modalView animated:NO];
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.modalView withMessage:NSLocalizedString(@"empty_category_no_product", nil)];
            return;
        }
        
        if (!data) {
            return;
        }
        
        ProductDetailModel *product = [[ProductDetailModel alloc] initWithDictionary:data error:nil];
        if (!product) {
            return;
        }
        
        [weakSelf.loadedProductIds addObject:[NSNumber numberWithInteger:productId]];
        [weakSelf.products addObject:product];
        [weakSelf switchToNewProduct:[product copy]];
        [weakSelf.collectionView reloadData];
    }];
}

- (void)switchToNewProduct:(ProductDetailModel *)product {
    _product.productId = product.productId;
    _product.image = product.image;
    _product.images = product.images;
    _product.name = product.name;
    _product.special = product.special;
    _product.price = product.price;
    _product.specialFormat = product.specialFormat;
    _product.priceFormat = product.priceFormat;
    _product.quantity = product.quantity;
    _product.minimum = product.minimum;
    _product.options = product.options;
    _product.reviews = product.reviews;
    _product.addedWishlist = product.addedWishlist;
    _product.relatedProducts = product.relatedProducts;
    
    _nameLabel.text = _product.name;
    _priceLabel.text = _product.special ? _product.specialFormat : _product.priceFormat;
    [_imageView lazyLoad:_product.image];

    _shouldReloadProductTableView = YES;
    [self updateConfirmButtonState];
}

- (void)updateConfirmButtonState {
    _confirmButton.enabled = _product.quantity > 0;
    if (_confirmButton.isEnabled) {
        _confirmButton.backgroundColor = CONFIG_PRIMARY_COLOR;
    } else {
        _confirmButton.backgroundColor = [UIColor darkGrayColor];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.debugDescription);
}
@end
