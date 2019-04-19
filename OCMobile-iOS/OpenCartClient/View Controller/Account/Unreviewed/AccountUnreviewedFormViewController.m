//
//  AccountUnreviewedFormViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 7/5/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountUnreviewedFormViewController.h"
#import "LoginViewController.h"
#import "TextViewOnlyCell.h"
#import "RatingStarSelectorCell.h"
#import "GDTableFormFooterButtonView.h"

@interface AccountUnreviewedFormViewController ()
@property (strong, nonatomic) NSString *comment;
@property (assign, nonatomic) NSInteger rating;
@end

@implementation AccountUnreviewedFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"text_account_unreviewed_form_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerClass:[TextViewOnlyCell class] forCellReuseIdentifier:kCellIdentifier_TextViewOnlyCell];
    [self.tableView registerClass:[RatingStarSelectorCell class] forCellReuseIdentifier:kCellIdentifier_RatingStarSelectorCell];

    GDTableFormFooterButtonView *confirmButtonView = [[GDTableFormFooterButtonView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [confirmButtonView.button addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = confirmButtonView;

    _rating = 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;

    switch (indexPath.row) {
        case 0: {
            RatingStarSelectorCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_RatingStarSelectorCell forIndexPath:indexPath];
            cell.label.text = NSLocalizedString(@"label_account_unreviewed_form_rating", nil);
            cell.ratingView.value = _rating;
            cell.ratingValueChangedBlock = ^(NSInteger rating) {
                weakSelf.rating = rating;
            };

            return cell;

            break;
        }
        case 1: {
            TextViewOnlyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TextViewOnlyCell forIndexPath:indexPath];
            [cell setPlaceholder:NSLocalizedString(@"label_account_unreviewed_form_comment", nil) value:_comment];
            cell.textViewValueChangedBlock = ^(NSString *value) {
                weakSelf.comment = value;
            };

            return cell;
            break;
        }
    }

    return nil;
}

- (void)saveButtonClicked {
    [self.view endEditing:YES];

    if (_rating < 1 || _rating > 5) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_rating_number_range", nil)];
        return;
    }

    if (!_comment.length || _comment.length < 5) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_review_content_min", nil)];
        return;
    }

    if (_comment.length > 200) {
        [MBProgressHUD showToastToView:self.view withMessage:NSLocalizedString(@"toast_review_content_max", nil)];
        return;
    }

    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"id": [NSNumber numberWithInteger:_orderProductId],
                             @"text": _comment,
                             @"rating": [NSNumber numberWithFloat: _rating],
                             };
    __weak typeof(self) weakSelf = self;

    [[Network sharedInstance] POST:[NSString stringWithFormat:@"order_products/%ld/reviews", (long)_orderProductId] params:params callback:^(NSDictionary *data, NSString *error) {
        if (data) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.navigationController.view withMessage:NSLocalizedString(@"toast_review_submit_success", nil)];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }

        if (error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }
    }];
}
@end
