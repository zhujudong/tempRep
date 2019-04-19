//
//  StripePaymentViewController.m
//  afterschoollol
//
//  Created by Sam Chen on 08/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "StripePaymentViewController.h"
#import "CreditCardListItemCell.h"
#import "CreditCradModalView.h"
#import <Stripe/Stripe.h>
#import "StripeNewCardModel.h"
#import "StripeStoredCardsModel.h"

static CGFloat const NAV_HEIGHT = 64.0;

@interface StripePaymentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *cardButton;
@property (strong, nonatomic) UIButton *cancelButton;

@property (strong, nonatomic) CreditCradModalView *creditCardModal;
@property (strong, nonatomic) StripeStoredCardsModel *cardsModel;
@property (strong, nonatomic) StripeNewCardModel *card;

@end

@implementation StripePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = CONFIG_GENERAL_BG_COLOR;

    // Register Stripe
    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey: CONFIG_STRIPE_LIVE_MODE ? CONFIG_STRIPE_LIVE_KEY : CONFIG_STRIPE_TEST_KEY];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[CreditCardListItemCell class] forCellReuseIdentifier:kCellIdentifier_CreditCardListItemCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.leading.trailing.bottom.equalTo(self.view);
    }];

    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setImage:[UIImage imageNamed:@"close_small"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.leading.equalTo(self.view).offset(20);
    }];

    _cardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cardButton setTitle:NSLocalizedString(@"button_new_credit_card", nil) forState:UIControlStateNormal];
    [_cardButton setTitleColor:[UIColor colorWithHexString:@"333333" alpha:1] forState:UIControlStateNormal];
    _cardButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cardButton addTarget:self action:@selector(newCardButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cardButton];
    [_cardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelButton);
        make.trailing.equalTo(self.view).offset(-20);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self callStoredCardsAPI];
}

#pragma mark - tableview protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cardsModel.cards.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CreditCardListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CreditCardListItemCell];
    [cell setCard:[_cardsModel.cards objectAtIndex:indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    StripeStoredCardModel *card = [_cardsModel.cards objectAtIndex:indexPath.section];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"label_select_credit_card", nil) message:[NSString stringWithFormat:NSLocalizedString(@"text_select_credit_card_confirm", nil), card.lastFourDigits] preferredStyle:UIAlertControllerStyleAlert];


            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self callSubmitStoredCardAPI:card];
            }];
            [alertController addAction:okAction];

            [self presentViewController:alertController animated:YES completion:nil];
        });
    });
}

#pragma mark - Button action
- (void)newCardButtonClicked {
    __weak typeof(self) weakSelf = self;
    _creditCardModal = [[CreditCradModalView alloc] initWithFrame:self.view.bounds];
    _creditCardModal.dismissable = _cardsModel.cards.count;
    _creditCardModal.saveCardEnabled = _stripe.saveCards;
    [self.view addSubview:_creditCardModal];
    [_creditCardModal show];

    _creditCardModal.submitButtonClickedBlock = ^(StripeNewCardModel *card) {
        [weakSelf callSubmitNewCardAPI:card];
    };

    _creditCardModal.cancelButtonClickedBlock = ^{
        if (weakSelf.cardsModel.cards.count <= 0) {
            [weakSelf cancelButtonClicked];
        }
    };
}

- (void)cancelButtonClicked {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"toast_cancel_payment_confirm", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_cancel", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:cancelAction];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"button_confirm", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate stripePaymentFinished:NO];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - API
- (void)callStoredCardsAPI {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];

    NSDictionary *params = @{@"mode": CONFIG_STRIPE_LIVE_MODE ? @"live" : @"test",
                             };

    [[Network sharedInstance] GET:@"account/me/stripe_cards" params:params callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }

        if (data) {
            weakSelf.cardsModel = [[StripeStoredCardsModel alloc] initWithDictionary:data error:nil];

            if (_cardsModel.cards.count) {
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf newCardButtonClicked];
            }
        }
    }];
}

- (void)callSubmitNewCardAPI:(StripeNewCardModel *)card {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    NSDictionary *cardData = @{@"number": card.cardNumber,
                               @"exp_month": card.expirationMonth,
                               @"exp_year": [NSString stringWithFormat:@"20%@", card.expirationYear],
                               @"cvc": card.cvc,
                               @"save_card": card.saveCard ? @"true" : @"false"
                               };
    NSData *json = [NSJSONSerialization dataWithJSONObject:cardData options:0 error:nil];

    NSDictionary *params = @{@"order_id": _orderId,
                             @"mode": CONFIG_STRIPE_LIVE_MODE ? @"live" : @"test",
                             @"card": [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding]
                             };

    [[Network sharedInstance] POST:@"callbacks/stripe" params:params callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }

        if (data) {
            [weakSelf.creditCardModal dismiss];
            [self.delegate stripePaymentFinished:YES];
        }
    }];
}

- (void)callSubmitStoredCardAPI:(StripeStoredCardModel *)card {
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showLoadingHUDToView:self.view];
    NSDictionary *params = @{@"order_id": _orderId,
                             @"mode": CONFIG_STRIPE_LIVE_MODE ? @"live" : @"test",
                             @"source": card.cardId
                             };

    [[Network sharedInstance] POST:@"callbacks/stripe" params:params callback:^(NSDictionary *data, NSString *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (error) {
            [MBProgressHUD showToastToView:weakSelf.view withMessage:error];
        }

        if (data) {
            [weakSelf.creditCardModal dismiss];
            [self.delegate stripePaymentFinished:YES];
        }
    }];
}
@end
