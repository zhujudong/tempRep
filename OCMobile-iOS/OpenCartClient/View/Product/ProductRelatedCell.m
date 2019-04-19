//
//  ProductRelatedCell.m
//  OpenCartClient
//
//  Created by Sam Chen on 31/12/2016.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "ProductRelatedCell.h"
#import "GDStrikeThroughLabel.h"
#import "ProductGridItemModel.h"

static CGFloat const PRODUCT_ITEM_CELL_GUTTER = 10.0;
static NSInteger const PRODUCT_ITEM_PER_ROW = 3;

// ==============================
// CollectionViewCell
// Related collection view cell inside current tableview cell
#define kCellIdentifier_ProductRelatedCollectionCell @"ProductRelatedCollectionCell"

@interface ProductRelatedCollectionCell : UICollectionViewCell
@property (strong, nonatomic) ProductRelatedProductItemModel *product;
@end

@interface ProductRelatedCollectionCell()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel, *priceLabel;
@property (strong, nonatomic) GDStrikeThroughLabel *priceOldLabel;
@end

@implementation ProductRelatedCollectionCell
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder"]];

            [self.contentView addSubview:_imageView];
            [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.and.trailing.equalTo(self.contentView);
                make.height.equalTo(_imageView.mas_width);
            }];
        }

        if (!_nameLabel) {
            _nameLabel = [UILabel new];
            _nameLabel.textColor = [UIColor colorWithHexString:@"252525" alpha:1];
            _nameLabel.font = [UIFont systemFontOfSize:12];

            [self.contentView addSubview:_nameLabel];
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView.mas_bottom).offset(6);
                make.leading.equalTo(self.contentView).offset(6);
                make.trailing.equalTo(self.contentView).offset(-6);
            }];
        }

        if (!_priceLabel) {
            _priceLabel = [UILabel new];
            _priceLabel.font = [UIFont boldSystemFontOfSize:12];
            _priceLabel.textColor = CONFIG_PRIMARY_COLOR;

            [self.contentView addSubview:_priceLabel];
            [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_nameLabel.mas_bottom).offset(6);
                make.leading.equalTo(_nameLabel.mas_leading);
            }];
        }

        if (!_priceOldLabel) {
            _priceOldLabel = [GDStrikeThroughLabel new];
            _priceOldLabel.font = [UIFont systemFontOfSize:12];
            _priceOldLabel.textColor = [UIColor colorWithHexString:@"808080" alpha:1];

            [self.contentView addSubview:_priceOldLabel];
            [_priceOldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_priceLabel.mas_trailing).offset(10);
                make.centerY.equalTo(_priceLabel);
            }];
        }
    }

    return self;
}

- (void)setProduct:(ProductRelatedProductItemModel *)product {
    _product = product;

    [_imageView lazyLoad:_product.image];
    _nameLabel.text = _product.name;

    if (_product.special) {
        _priceLabel.text = _product.specialFormat;
        _priceOldLabel.text = _product.priceFormat;
    } else {
        _priceLabel.text = _product.priceFormat;
        _priceOldLabel.text = nil;
    }
}
@end


// ==============================
// CELL
@interface ProductRelatedCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@end

@implementation ProductRelatedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;

        if (!_collectionView) {
            _layout = [[UICollectionViewFlowLayout alloc] init];
            _layout.minimumLineSpacing = PRODUCT_ITEM_CELL_GUTTER;
            _layout.minimumInteritemSpacing = PRODUCT_ITEM_CELL_GUTTER;
            _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

            CGFloat width = (SCREEN_WIDTH - (PRODUCT_ITEM_PER_ROW * PRODUCT_ITEM_CELL_GUTTER) + PRODUCT_ITEM_CELL_GUTTER) / PRODUCT_ITEM_PER_ROW;
            CGFloat height = width + (16 * 2) + (6 * 3);
            _layout.itemSize = CGSizeMake(width, height);

            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.showsVerticalScrollIndicator = NO;
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.pagingEnabled = YES;
            _collectionView.alwaysBounceHorizontal = YES;

            [_collectionView registerClass:[ProductRelatedCollectionCell class] forCellWithReuseIdentifier:kCellIdentifier_ProductRelatedCollectionCell];

            [self.contentView addSubview:_collectionView];
            [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(_layout.itemSize.height).priorityHigh();
                make.top.equalTo(self.contentView).offset(10);
                make.leading.trailing.and.bottom.equalTo(self.contentView);
            }];
        }
    }

    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _products ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductRelatedCollectionCell *cell = (ProductRelatedCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_ProductRelatedCollectionCell forIndexPath:indexPath];
    ProductRelatedProductItemModel *product = [_products objectAtIndex:indexPath.row];

    [cell setProduct:product];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.relatedProductClickedBlock) {
        ProductRelatedProductItemModel *product = [_products objectAtIndex:indexPath.row];
        NSLog(@"selected related product id: %ld",(long) product.productId);
        _relatedProductClickedBlock(product.productId);
    }
}

- (void)setProducts:(NSArray<ProductRelatedProductItemModel> *)products {
    _products = products;

    [_collectionView reloadData];
}

@end
