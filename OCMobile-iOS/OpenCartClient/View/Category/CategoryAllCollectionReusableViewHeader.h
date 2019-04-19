//
//  CategoryAllCollectionReusableViewHeader.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/31/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CategoryAllCollectionReusableViewHeader @"CategoryAllCollectionReusableViewHeader"

@interface CategoryAllCollectionReusableViewHeader : UICollectionReusableView

@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UILabel *nameLabel;

@end
