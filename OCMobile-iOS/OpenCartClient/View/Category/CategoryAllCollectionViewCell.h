//
//  CategoryAllCollectionViewCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/30/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CategoryAllCollectionViewCell @"CategoryAllCollectionViewCell"

@interface CategoryAllCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *nameLabel;

- (void)setImage:(NSString *)image name:(NSString *)name;

@end
