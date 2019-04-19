//
//  BearyChatAttachmentModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol BearyChatAttachmentModel;

@interface BearyChatAttachmentModel : JSONModel
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *text;
@end
