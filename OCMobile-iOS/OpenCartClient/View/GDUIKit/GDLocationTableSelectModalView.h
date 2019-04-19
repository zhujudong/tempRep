//
//  GDLocationTableSelectView.h
//  afterschoollol
//
//  Created by Sam Chen on 18/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"

@interface GDLocationTableSelectModalView : UIView

@property (strong, nonatomic) LocationModel *location;
@property (nonatomic, copy) void(^locationValueChanged)(NSArray *names, NSArray *ids);

- (void)show;
- (void)initSelectedRows:(NSArray *)rows;
@end
