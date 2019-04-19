//
//  GDLocationTableSelectView.m
//  afterschoollol
//
//  Created by Sam Chen on 18/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "GDLocationTableSelectModalView.h"
#import "GDLocationSelectTableViewCell.h"

static CGFloat const MODAL_VIEW_HEIGHT_PERCENT = 0.55;
static CGFloat const CANCEL_BUTTON_HEIGHT = 50.0;

@interface GDLocationTableSelectModalView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *modalView;
@property (strong, nonatomic) UIButton *cancelButton, *saveButton;
@property (strong, nonatomic) UIView *sepLine;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *tableViews;
@property (strong, nonatomic) NSMutableArray *levels;
@property (strong, nonatomic) NSMutableArray *selectedRows, *selectedNames, *selectedIds;

@end

@implementation GDLocationTableSelectModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.window = [[UIApplication sharedApplication] keyWindow];

        if (!_maskView) {
            _maskView = [[UIView alloc] initWithFrame:frame];
            _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
            _maskView.alpha = 0.0;
            [self addSubview:_maskView];
        }

        if (!_modalView) {
            _modalView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * MODAL_VIEW_HEIGHT_PERCENT)];

            _modalView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_modalView];
        }

        if (!_cancelButton) {
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_cancelButton setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
            [_cancelButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_modalView addSubview:_cancelButton];
            [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.leading.equalTo(_modalView).offset(10);
            }];
        }

        if (!_saveButton) {
            _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_saveButton setTitle:NSLocalizedString(@"button_confirm", nil) forState:UIControlStateNormal];
            [_saveButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [_saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_modalView addSubview:_saveButton];
            [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(_modalView).offset(-10);
                make.centerY.equalTo(_cancelButton);
            }];
        }

        if (!_sepLine) {
            _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CANCEL_BUTTON_HEIGHT, SCREEN_WIDTH, 0.5)];
            _sepLine.backgroundColor = CONFIG_DEFAULT_SEPARATOR_LINE_COLOR;
            [_modalView addSubview:_sepLine];
        }

        if (!_scrollView) {
            _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CANCEL_BUTTON_HEIGHT + 0.5, SCREEN_WIDTH, CGRectGetHeight(_modalView.frame) - CANCEL_BUTTON_HEIGHT)];
            _scrollView.pagingEnabled = YES;
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.scrollEnabled = NO;
            [_modalView addSubview:_scrollView];
        }

        _tableViews = [[NSMutableArray alloc] init];
        _levels = [[NSMutableArray alloc] init];
        _selectedNames = [[NSMutableArray alloc] init];
        _selectedIds = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - Set data
- (void)setLocation:(LocationModel *)location {
    _location = location;
}

- (void)initSelectedRows:(NSArray *)rows {
    _selectedRows = [[NSMutableArray alloc] initWithArray:rows];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = [_levels lastObject];
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GDLocationSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_GDLocationSelectTableViewCell];
    NSArray<LocationItemModel> *items = [_levels lastObject];
    LocationItemModel *item = [items objectAtIndex:indexPath.row];
    [cell setText:item.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_selectedRows addObject:[NSNumber numberWithInteger:indexPath.row]];

    NSArray *items = [_levels lastObject];
    LocationItemModel *item = [items objectAtIndex:indexPath.row];
    [_selectedIds addObject:[NSNumber numberWithInteger:item.id]];
    [_selectedNames addObject:item.name];

    // Can go next level
    if (item.items.count > 0) {
        [_levels addObject:item.items];
        [self pushToNextTableView];
    } else {
        if (_locationValueChanged) {
            self.locationValueChanged(_selectedNames, _selectedIds);
        }
        [self dismiss];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - prepare tableview
- (void)pushToNextTableView {
    CGRect frame = CGRectMake(SCREEN_WIDTH * _tableViews.count, 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [_tableViews addObject:tableView];
    [self styleTableView:tableView];
    [_scrollView addSubview:tableView];

    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (_tableViews.count - 1), 0) animated:YES];
//    [self.cancelButton setTitle:NSLocalizedString(@"button_back", nil) forState:UIControlStateNormal];
    NSNumber *row = [_selectedRows objectAtIndex:_tableViews.count - 1];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row.integerValue inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}

- (void)popToPreviousTableView {
    [_scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - SCREEN_WIDTH, 0) animated:YES];
    UITableView *tableView = [_tableViews lastObject];
    [tableView removeFromSuperview];
    tableView.delegate = nil;
    tableView.dataSource = nil;
    [_tableViews removeLastObject];
    [_levels removeLastObject];
    [_selectedRows removeLastObject];
    [_selectedNames removeLastObject];
    [_selectedIds removeLastObject];

//    [self.cancelButton setTitle:NSLocalizedString(@"button_cancel", nil) forState:UIControlStateNormal];
}

#pragma mark - Actions
- (void)cancelButtonClicked {
    if (self.scrollView.contentOffset.x <= 0) {
        [self dismiss];
    } else {
        [self popToPreviousTableView];
    }
}

- (void)saveButtonClicked {
    //
}

#pragma mark - Animation
- (void)show {
    [self.window addSubview:self];

    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 1.0;

        CGRect frame = _modalView.frame;
        frame.origin.y = SCREEN_HEIGHT * (1 - MODAL_VIEW_HEIGHT_PERCENT);
        _modalView.frame = frame;
    } completion:^(BOOL finished) {
        NSArray<LocationItemModel> *items = _location.items;
        [_levels addObject:items];
        [self pushToNextTableView];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        _maskView.alpha = 0;

        CGRect frame = _modalView.frame;
        frame.origin.y = SCREEN_HEIGHT;
        _modalView.frame = frame;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [_modalView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Private
- (void)styleTableView:(UITableView *)tableView {
    tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    tableView.estimatedRowHeight = 20;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedSectionHeaderHeight = 2;
    tableView.estimatedSectionHeaderHeight = 0;
    [tableView registerClass:[GDLocationSelectTableViewCell class] forCellReuseIdentifier:kCellIdentifier_GDLocationSelectTableViewCell];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.description);
}
@end
