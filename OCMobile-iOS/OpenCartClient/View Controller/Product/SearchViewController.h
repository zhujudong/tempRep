//
//  SearchViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 6/18/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (assign, nonatomic) BOOL pushedFromViewController;

@end
