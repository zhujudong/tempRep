//
//  GCPlaceholderTextView.h
//  GCLibrary
//
//  Created by Guillaume Campagna on 10-11-16.
//  Copyright 2010 LittleKiwi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCPlaceholderTextView : UITextView

@property(strong, nonatomic) NSString *placeholder;

@property (strong, nonatomic) UIColor *realTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *placeholderColor UI_APPEARANCE_SELECTOR;

@property (copy, nonatomic) void(^textViewValueChangedBlock)(NSString *);
@end
