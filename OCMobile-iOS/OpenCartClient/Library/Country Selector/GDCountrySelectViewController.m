//
//  GDCountrySelectViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 19/01/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "GDCountrySelectViewController.h"
#import "NBPhoneNumberUtil.h"

static NSString *kCellIdentifier_CountryCell = @"CountryCell";

@interface GDCountrySelectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation GDCountrySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:[UIImage imageNamed:@"close_large"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.trailing.equalTo(self.view).offset(-20);
    }];

    _titleLabel = [UILabel new];
    _titleLabel.text = NSLocalizedString(@"title_select_mobile_region", nil);
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_closeButton);
        make.centerX.equalTo(self.view);
    }];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 0;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier_CountryCell];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_closeButton.mas_bottom).offset(10);
        make.leading.bottom.and.trailing.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _callingCodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CallingCodeModel *callingCode = [_callingCodes objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CountryCell];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ +%@", callingCode.name, callingCode.code];
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.countrySelectedBlock) {
        CallingCodeModel *callingCode = [_callingCodes objectAtIndex:indexPath.row];
        self.countrySelectedBlock(callingCode.code);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
