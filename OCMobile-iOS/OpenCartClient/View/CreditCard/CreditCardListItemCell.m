//
//  CreditCardListItemCell.m
//  afterschoollol
//
//  Created by Sam Chen on 10/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "CreditCardListItemCell.h"

static CGFloat const CELL_HEIGHT = 190.0;

@interface CreditCardListItemCell()
@property (strong, nonatomic) UIImageView *cardBackgroundImgeView;
@property (strong, nonatomic) UILabel *cardNumberTitleLabel, *cardNumberLabel;
@property (strong, nonatomic) UIImageView *cardTypeImageView;
@property (strong, nonatomic) UILabel *expireTitleLabel, *expireLabel;
@end

@implementation CreditCardListItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!_cardBackgroundImgeView) {
            _cardBackgroundImgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"credit-card-1"]];
            [self.contentView addSubview:_cardBackgroundImgeView];
            [_cardBackgroundImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
                make.height.mas_equalTo(CELL_HEIGHT);
            }];
        }

        if (!_cardNumberLabel) {
            _cardNumberLabel = [[UILabel alloc] init];
            _cardNumberLabel.text = @"**** **** **** ****";
            _cardNumberLabel.textColor = [UIColor whiteColor];
            _cardNumberLabel.font = [UIFont boldSystemFontOfSize:28];
            _cardNumberLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            _cardNumberLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            [self.contentView addSubview:_cardNumberLabel];
            [_cardNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
            }];
        }

        if (!_cardNumberTitleLabel) {
            _cardNumberTitleLabel = [[UILabel alloc] init];
            _cardNumberTitleLabel.text = @"Card Number";
            _cardNumberTitleLabel.textColor = [UIColor whiteColor];
            _cardNumberTitleLabel.font = [UIFont systemFontOfSize:14];
            _cardNumberTitleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            _cardNumberTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            [self.contentView addSubview:_cardNumberTitleLabel];
            [_cardNumberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(30);
                make.bottom.equalTo(_cardNumberLabel.mas_top).offset(-2);
            }];
        }

        if (!_expireTitleLabel) {
            _expireTitleLabel = [[UILabel alloc] init];
            _expireTitleLabel.text = @"VALID THRU";
            _expireTitleLabel.textColor = [UIColor whiteColor];
            _expireTitleLabel.font = [UIFont systemFontOfSize:10];
            _expireTitleLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            _expireTitleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            [self.contentView addSubview:_expireTitleLabel];
            [_expireTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.contentView).offset(30);
                make.bottom.equalTo(self.contentView).offset(-44);
            }];
        }

        if (!_expireLabel) {
            _expireLabel = [[UILabel alloc] init];
            _expireLabel.text = @"12/19";
            _expireLabel.textColor = [UIColor whiteColor];
            _expireLabel.font = [UIFont systemFontOfSize:14];
            _expireLabel.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
            _expireLabel.shadowOffset = CGSizeMake(1.0, 1.0);
            [self.contentView addSubview:_expireLabel];
            [_expireLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(_expireTitleLabel);
                make.top.equalTo(_expireTitleLabel.mas_bottom).offset(0);
            }];
        }

        if (!_cardTypeImageView) {
            _cardTypeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card-visa"]];
            _cardTypeImageView.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_cardTypeImageView];
            [_cardTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(self.contentView).offset(-30);
                make.top.equalTo(self.contentView).offset(30);
            }];
        }
    }

    return self;
}

- (void)setCard:(StripeStoredCardModel *)card {
    _card = card;

    _cardNumberLabel.text = [NSString stringWithFormat:@"**** **** **** %@", _card.lastFourDigits];
    _expireLabel.text = _card.expirationFormat;
    _cardBackgroundImgeView.image = [UIImage imageNamed:[NSString stringWithFormat:@"credit-card-%ld", (long)_card.creditCardCode]];
    _cardTypeImageView.image = [UIImage imageNamed:[_card creditCardThumbnailName]];
}

@end
