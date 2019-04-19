//
//  AccountLanguageViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 17/10/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "AccountLanguageViewController.h"
#import "LabelWithDescriptionCell.h"
#import "BundleLocalization.h"
#import "AppDelegate.h"

@interface AccountLanguageViewController ()

@end

@implementation AccountLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"text_account_language_title", nil);

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = CONFIG_GENERAL_BG_COLOR;
    self.tableView.estimatedRowHeight = 50.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[LabelWithDescriptionCell class] forCellReuseIdentifier:kCellIdentifier_LabelWithDescriptionCell];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LabelWithDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_LabelWithDescriptionCell forIndexPath:indexPath];
    [cell setPlaceholder:(indexPath.row == 0 ? @"English" : @"简体中文") description:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { // en
        if ([[System sharedInstance] isSimplifiedChineseLanguage] == NO) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    if (indexPath.row == 1) { // zh-Hans
        if ([[System sharedInstance] isSimplifiedChineseLanguage] == YES) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    
    NSString *languageCode = indexPath.row == 0 ? @"en" : @"zh-Hans";
    [[BundleLocalization sharedInstance] setLanguage:languageCode];
    NSLog(@"Application language changed to: %@", [BundleLocalization sharedInstance].language);
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) reloadRootViewControllerWhenLanguageChanged];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
@end
