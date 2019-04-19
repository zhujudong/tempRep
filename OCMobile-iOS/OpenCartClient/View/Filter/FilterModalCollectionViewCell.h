//
//  FilterModalCollectionViewCell.h
//  OpenCartClient
//
//  Created by Sam Chen on 2018/5/31.
//  Copyright © 2018 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterModalCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString *name;

+ (NSString *)identifier;
- (void)setActive:(BOOL)active;

@end
