//
//  FilterModalView.m
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import "FilterModalView.h"
#import "FilterModalCollectionViewCell.h"
#import "FilterModalCollectionViewHeaderView.h"
#import "EmptyView.h"

static CGFloat const MODAL_VIEW_WIDTH_PERCENT = 0.8;
static CGFloat const BUTTON_HEIGHT = 50;
static CGFloat const COLLECTION_VIEW_MARGIN_Y = 20;
static CGFloat const COLLECTION_VIEW_MARGIN_X = 20;
static CGFloat const CELL_GUTTER = 20;
static CGFloat const CELL_HEIGHT = 34;
static NSInteger const CELL_PER_ROW = 3;
static CGFloat const CELL_HEADER_HEIGHT = 60;
static NSInteger const MAX_SELECT_VALUE_TOTAL = 5;

@interface FilterModalView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIButton *cancelButton, *confirmButton;
@property (assign, nonatomic) CGSize collectionViewHeaderSize;
@property (assign, nonatomic) NSInteger expandedSectionIndex;
@end

@implementation FilterModalView

- (instancetype)init {
    self.window = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = self.window.frame;

    self = [super initWithFrame:frame];

    if (self) {
        self.window = [[UIApplication sharedApplication] keyWindow];

        _maskView = [[UIView alloc] initWithFrame:frame];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _maskView.alpha = 0.0;
        [self addSubview:_maskView];

        _modalView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, [self modalViewWidth], SCREEN_HEIGHT)];

        _modalView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_modalView];

        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_cancelButton];

        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _confirmButton.backgroundColor = CONFIG_PRIMARY_COLOR;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_modalView addSubview:_confirmButton];

        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.equalTo(_modalView);
            make.height.mas_equalTo(BUTTON_HEIGHT);
            make.width.equalTo(_confirmButton);
        }];

        [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.bottom.equalTo(_modalView);
            make.height.mas_equalTo(BUTTON_HEIGHT);
            make.width.equalTo(_cancelButton);
            make.leading.equalTo(_cancelButton.mas_trailing);
        }];

        // Collection view
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = CELL_GUTTER;
        layout.minimumInteritemSpacing = CELL_GUTTER;
        layout.itemSize = CGSizeMake([self collectionViewCellWidth], CELL_HEIGHT);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[FilterModalCollectionViewCell class] forCellWithReuseIdentifier:[FilterModalCollectionViewCell identifier]];
        [_collectionView registerClass:[FilterModalCollectionViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[FilterModalCollectionViewHeaderView identifier]];
        [_modalView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_modalView).offset(COLLECTION_VIEW_MARGIN_Y);
            make.leading.equalTo(_modalView).offset(COLLECTION_VIEW_MARGIN_X);
            make.trailing.equalTo(_modalView).offset(-COLLECTION_VIEW_MARGIN_X);
            make.bottom.equalTo(_cancelButton.mas_top).offset(-COLLECTION_VIEW_MARGIN_Y);
        }];
    }

    self.expandedSectionIndex = -1;

    return self;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sections = [_filters sections];

    if (sections < 1) {
        EmptyView *emptyView = [[EmptyView alloc] initWithFrame:_modalView.bounds];
        emptyView.textLabel.text = @"没有筛选条件";
        [emptyView.reloadButton setHidden:YES];
        collectionView.backgroundView = emptyView;
    } else {
        collectionView.backgroundView = nil;
    }

    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger number = [_filters numberOfItemsInSection:section];
    
    if (_expandedSectionIndex == section) {
        return number;
    }
    return MIN(number, CELL_PER_ROW);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterModalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FilterModalCollectionViewCell identifier] forIndexPath:indexPath];
    cell.name = [_filters sectionValueNameAtIndexPath:indexPath];
    [cell setActive:[_filters isValueSelectedAtIndexPath:indexPath]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        __weak typeof(self) weakSelf = self;
        FilterModalCollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[FilterModalCollectionViewHeaderView identifier] forIndexPath:indexPath];
        view.sectionIndex = indexPath.section;
        view.name = [_filters sectionName:indexPath.section];
        view.showAllButton = [_filters numberOfItemsInSection:indexPath.section] > CELL_PER_ROW;
        view.headerViewClickedBlock = ^(NSInteger sectionIndex) {
            [weakSelf expandSection:sectionIndex];
        };
        return view;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.collectionViewHeaderSize.width == 0) {
        self.collectionViewHeaderSize = CGSizeMake(self.collectionView.bounds.size.width, CELL_HEADER_HEIGHT);
    }
    return self.collectionViewHeaderSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Max selection check
    if (![_filters isValueSelectedAtIndexPath:indexPath] && MAX_SELECT_VALUE_TOTAL > 0 && [_filters totalSelectedValuesInSection:indexPath.section] >= MAX_SELECT_VALUE_TOTAL) {
        [MBProgressHUD showToastToView:self withMessage:[NSString stringWithFormat:@"最多只可选择 %ld 个选项", (long)MAX_SELECT_VALUE_TOTAL]];
        return;
    }
    
    // Select or unselect
    FilterModalCollectionViewCell *cell = (FilterModalCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    BOOL isSelected = [_filters selectValueAtIndexPath:indexPath];
    [cell setActive: isSelected];
}

#pragma mark - Animation
- (void)show {
    [self.window addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 1.0;

        CGRect frame = _modalView.frame;
        frame.origin.x = SCREEN_WIDTH - [self modalViewWidth];
        _modalView.frame = frame;
    } completion:^(BOOL finished) {
        // TODO
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0;

        CGRect frame = _modalView.frame;
        frame.origin.x = SCREEN_WIDTH;
        _modalView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Actions
- (void)cancelButtonClicked {
    [self dismiss];
}

- (void)confirmButtonClicked {
    [self dismiss];
    if ([_filters sections] > 0 && self.submitButtonClickedBlock) {
        _submitButtonClickedBlock();
    }
}

#pragma mark - private
- (CGFloat)modalViewWidth {
    return SCREEN_WIDTH * MODAL_VIEW_WIDTH_PERCENT;
}

- (CGFloat)collectionViewCellWidth {
    CGFloat width = ([self modalViewWidth] - (COLLECTION_VIEW_MARGIN_X * 2) - (CELL_GUTTER * (CELL_PER_ROW - 1))) / CELL_PER_ROW;
    return width;
}

- (void)expandSection:(NSInteger) index {
    if (_expandedSectionIndex == index) {
        _expandedSectionIndex = -1;
    } else {
        _expandedSectionIndex = index;
    }
    [_collectionView reloadData];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.description);
}
@end
