//
//  StatusModel.h
//  JSONModel-Test
//
//  Created by Sam Chen on 1/22/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface StatusModel : JSONModel

//@property (nonatomic) NSInteger status;
@property (nonatomic) NSString *message;
@property (nonatomic) NSDictionary<Optional> *data;

@end
