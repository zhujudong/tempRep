//
//  AccountCouponViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 6/28/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountCouponViewController.h"
#import "AccountCouponCell.h"
#import "AccountCouponCellStyle2.h"
#import "AccountCouponsModel.h"
#import "AccountCouponModel.h"
#import "LoginViewController.h"

@interface AccountCouponViewController ()
@property (strong, nonatomic) AccountCouponsModel *couponsModel;
@property (assign, nonatomic) NSInteger style; //coupon styles
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AccountCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_coupon_list", nil);
    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 100.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];

    //Choose coupon cell styles
    if ([[System sharedInstance] isSimplifiedChineseLanguage]) { // Chinese language uses style 1, default is 2
        _style = 1;
    } else {
        _style = 2;
    }

    if (_style == 1) {
        [_tableView registerClass:[AccountCouponCell class] forCellReuseIdentifier:kCellIdentifier_AccountCouponCell];
    } else {
        [_tableView registerClass:[AccountCouponCellStyle2 class] forCellReuseIdentifier:kCellIdentifier_AccountCouponCellStyle2];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self requestAPI];
}

- (void)requestAPI {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    [[Network sharedInstance] GET:@"account/me/coupons" params:nil callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
            weakSelf.couponsModel = [[AccountCouponsModel alloc] initWithDictionary:data error:nil];
            if (weakSelf.couponsModel.coupons.count > 0) {
                [weakSelf.tableView reloadData];
            }
        }

        if (error) {
            [weakSelf showToastMessageOnCurrentView:error];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _couponsModel.coupons.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;

    if (_style == 1) {
        cell = [self createCouponCellStyle1:indexPath];
    } else {
        cell = [self createCouponCellStyle2:indexPath];
    }


    return cell;
}

- (AccountCouponCell *)createCouponCellStyle1:(NSIndexPath *)indexPath {
    AccountCouponCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AccountCouponCell" forIndexPath:indexPath];

    AccountCouponModel *coupon = [_couponsModel.coupons objectAtIndex:indexPath.section];

    [cell setCoupon:coupon];

    return cell;
}

- (AccountCouponCellStyle2 *)createCouponCellStyle2:(NSIndexPath *)indexPath {
    AccountCouponCellStyle2 *cell = [_tableView dequeueReusableCellWithIdentifier:@"AccountCouponCellStyle2" forIndexPath:indexPath];

    AccountCouponModel *coupon = [_couponsModel.coupons objectAtIndex:indexPath.section];

    [cell setCoupon:coupon];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.;
}

@end
