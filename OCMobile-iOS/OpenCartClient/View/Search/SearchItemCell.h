//
//  SearchItemCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_SearchItemCell @"SearchItemCell"

@interface SearchItemCell : UICollectionViewCell
@property (strong, nonatomic) NSString *keyword;

@end
