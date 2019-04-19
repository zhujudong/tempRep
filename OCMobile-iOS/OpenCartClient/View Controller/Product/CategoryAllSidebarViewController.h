//
//  CategoryAllSidebarViewController.h
//  OpenCartClient
//
//  Created by Sam Chen on 1/23/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "StatusModel.h"
#import "CategoryFirstLevelAllModel.h"
#import "CategorySecondAndThirdLevelModel.h"

@interface CategoryAllSidebarViewController :BaseViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end
