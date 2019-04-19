//
//  BearyChatModel.h
//  OpenCartClient
//
//  Created by Sam Chen on 27/07/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "BearyChatAttachmentModel.h"

@interface BearyChatModel : JSONModel
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *channel;
@property (nonatomic) NSMutableArray<BearyChatAttachmentModel> *attachments;
@end
