//
//  AccountViewController.m
//  OpenCartClient
//
//  Created by Sam Chen on 2/6/16.
//  Copyright © 2016 opencart.cn. All rights reserved.
//

#import "AccountViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "StatusModel.h"
#import "AccountOrderHeaderCell.h"
#import "AccountOrderTypesButtonCell.h"
#import "AccountSimpleCell.h"
#import "AccountOrderListViewController.h"
#import "AccountEditViewController.h"
#import "Customer.h"
#import "UITabBarController+CartNumber.h"
#import "AccountCouponViewController.h"
#import "AccountReturnListViewController.h"
#import "AccountUnreviewedListViewController.h"
#import "AccountOrderListViewController.h"
#import "LoginViewController.h"
#import "AccountEditViewController.h"
#import "AccountRewardViewController.h"
#import "AccountPasswordViewController.h"
#import "AccountAddressListViewController.h"
#import "AccountWishlistViewController.h"
#import "AccountSettingViewController.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarController+CartNumber.h"

static CGFloat const IPHONE_TOP_VIEW_HEIGHT = 185.0;
static CGFloat const IPAD_TOP_VIEW_HEIGHT = 300.0;
static CGFloat const AVATAR_WIDTH = 80.0;
static CGFloat const IPHONEX_NAVBAR_HEIGHT = 44.0;
static CGFloat const NORMAL_NAVBAR_HEIGHT = 20.0;

#define MENU_ITEMS @[@"reward", @"coupon", @"orders", @"wishlist", @"edit", @"password", @"address"]

typedef NS_ENUM(NSInteger, AccountItemType) {
    AccountItemTypeReward,
    AccountItemTypeCoupon,
    AccountItemTypeOrder,
    //    AccountItemTypeReturn,
    AccountItemTypeWishlist,
    AccountItemTypeEdit,
    AccountItemTypePassword,
    AccountItemTypeAddress,
};

@interface AccountViewController ()

@property (strong, nonatomic) AccountModel *account;
@property (assign, nonatomic) BOOL isUploadingAvatar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *topRootView;
@property (strong, nonatomic) UIImageView *topBackgroundImageView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIButton *avatarButton, *settingButton;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _account = [[Customer sharedInstance] account];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF" alpha:1];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"DEDEDE" alpha:1];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake([self topViewHeight], 0, [[System sharedInstance] tabBarHeight], 0);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset([self navbarHeight] * -1);
        make.trailing.bottom.and.leading.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[AccountOrderHeaderCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderHeaderCell];
    [self.tableView registerClass:[AccountOrderTypesButtonCell class] forCellReuseIdentifier:kCellIdentifier_AccountOrderTypesButtonCell];
    [self.tableView registerClass:[AccountSimpleCell class] forCellReuseIdentifier:kCellIdentifier_AccountSimpleCell];
    
    self.tableView.estimatedRowHeight = 20.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [self createAvatarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    if (_isUploadingAvatar == NO) {
        [self callAccountAPI];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (animated) {
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= -[self topViewHeight]) { //Dropdown, zoom in
        CGRect frame = _topBackgroundImageView.frame;
        frame.origin.y = offsetY + [self topViewHeight];
        frame.size.height = [self topViewHeight] + ((offsetY + [self topViewHeight]) * -1);
        
        _topBackgroundImageView.frame = frame;
    }
}

- (void)createAvatarView {
    // Add root view
    _topRootView = [[UIView alloc] init];
    [self.tableView addSubview:_topRootView];
    [_topRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset([self topViewHeight] * -1);
        make.trailing.and.leading.equalTo(self.view);
        make.height.mas_equalTo([self topViewHeight]);
    }];

    // Add background image view
    _topBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_bg"]];
    [_topRootView addSubview:_topBackgroundImageView];
    [_topBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_topRootView);
    }];

    // Add avatar image view
    _avatarImageView = [UIImageView new];
    if (_account.avatar.length == 0 || [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_account.avatar] == nil) {
        _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
    } else {
        NSLog(@"Avatar in cache");
        _avatarImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_account.avatar];
    }

    _avatarImageView.backgroundColor = [UIColor whiteColor];
    _avatarImageView.layer.cornerRadius = AVATAR_WIDTH / 2;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.borderWidth = 2.0;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    gesture.numberOfTapsRequired = 1;
    [_avatarImageView addGestureRecognizer:gesture];

    [_topRootView addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topBackgroundImageView);
        make.size.mas_equalTo(CGSizeMake(AVATAR_WIDTH, AVATAR_WIDTH));
        if ([[System sharedInstance] isiPad]) {
            make.top.equalTo(_topBackgroundImageView).offset(60);
        } else {
            make.top.equalTo(_topBackgroundImageView).offset(36);
        }
    }];

    // Add login/username button
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_avatarButton setTitle:NSLocalizedString(@"button_login", nil) forState:UIControlStateNormal];
    [_avatarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _avatarButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_avatarButton addTarget:self action:@selector(goToLoginVC) forControlEvents:UIControlEventTouchUpInside];
    [_topRootView addSubview:_avatarButton];
    [_avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_avatarImageView);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(6);
    }];

    // Add settings button on top right corner
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_settingButton setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(goToSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [_topRootView addSubview:_settingButton];
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topRootView).offset(30);
        make.trailing.equalTo(_topRootView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

//设置 Status Bar 样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)callAccountAPI {
    if ([[Customer sharedInstance] isLogged]) {
        NSLog(@"Customer logged in.");
        _account = [[Customer sharedInstance] account];

        if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_account.avatar]) {
            _avatarImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_account.avatar];
        } else {
            _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        }

        [_avatarButton setTitle:_account.fullname forState:UIControlStateNormal];

        __weak typeof(self) weakSelf = self;
        [[Network sharedInstance] GET:@"account/me?width=200&height=200" params:nil callback:^(NSDictionary *data, NSString *error) {
            if (data) {
                AccountModel *newAccount = [[AccountModel alloc] initWithDictionary:data error:nil];
                if (newAccount) {
                    weakSelf.account = newAccount;
                    [[Customer sharedInstance] save:weakSelf.account];

                    if ([weakSelf.avatarButton.currentTitle isEqualToString:weakSelf.account.fullname] == NO) {
                        [weakSelf.avatarButton setTitle:weakSelf.account.fullname forState:UIControlStateNormal];
                    }

                    if (weakSelf.account.avatar.length) {
                        if ([[SDImageCache sharedImageCache] imageFromCacheForKey:weakSelf.account.avatar] == nil) {
                            [weakSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.account.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                [[SDImageCache sharedImageCache] storeImage:image forKey:weakSelf.account.avatar toDisk:YES completion:nil];
                            }];
                        } else {
                            NSLog(@"Avatar cached");
                        }
                    } else {
                        weakSelf.avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
                    }

                    [weakSelf.rdv_tabBarController updateCartNumber];
                    [weakSelf updateOrderButtonRedDotVisibility];
                }
            }
        }];
    } else {
        NSLog(@"Customer NOT logged in.");
        [_avatarButton setTitle:NSLocalizedString(@"button_login", nil) forState:UIControlStateNormal];
        _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        [self.rdv_tabBarController updateCartNumber];
        [self updateOrderButtonRedDotVisibility];
    }
}

- (void)updateOrderButtonRedDotVisibility {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            AccountOrderTypesButtonCell *cell = (AccountOrderTypesButtonCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            AccountModel *account = [[Customer sharedInstance] account];
            
            [cell.unpaidControl setRedDotHidden:account.unpaidOrders > 0 ? NO : YES];
            [cell.unshippedControl setRedDotHidden:account.paidOrders > 0 > 0 ? NO : YES];
            [cell.shippedControl setRedDotHidden:account.shippedOrders > 0 ? NO : YES];
            [cell.reviewControl setRedDotHidden:account.unreviewedOrderProducts > 0 ? NO : YES];
        });
    });
}

#pragma mark - TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 2;
            break;
        }
        case 1: {
            return MENU_ITEMS.count;
            break;
        }
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id returnCell = nil;
    switch (indexPath.section) {
        case 0: //order
        {
            switch (indexPath.row) {
                case 0: //order header
                {
                    AccountOrderHeaderCell *cell = [self createAccountOrderHeaderCell:indexPath];
                    returnCell = cell;
                }
                    break;
                case 1: // order types
                {
                    AccountOrderTypesButtonCell *cell = [self createAccountOrderTypesButtonCell:indexPath];
                    returnCell = cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1: //menu group 1
        {
            returnCell = [self createAccountSimpleCell:indexPath];
        }
            break;
        default:
            break;
    }
    
    return returnCell;
}

- (AccountOrderHeaderCell *)createAccountOrderHeaderCell:(NSIndexPath*) indexPath {
    AccountOrderHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderHeaderCell forIndexPath:indexPath];
    
    return cell;
}

- (AccountOrderTypesButtonCell *)createAccountOrderTypesButtonCell:(NSIndexPath*) indexPath {
    AccountOrderTypesButtonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountOrderTypesButtonCell forIndexPath:indexPath];
    
    [cell.unpaidControl addTarget:self action:@selector(didPressUnpaidControl) forControlEvents:UIControlEventTouchUpInside];
    [cell.unshippedControl addTarget:self action:@selector(didPressUnshippedControl) forControlEvents:UIControlEventTouchUpInside];
    [cell.shippedControl addTarget:self action:@selector(didPressShippedControl) forControlEvents:UIControlEventTouchUpInside];
    [cell.reviewControl addTarget:self action:@selector(didPressReviewControl) forControlEvents:UIControlEventTouchUpInside];
    [cell.returnControl addTarget:self action:@selector(didPressReturnControl) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (AccountSimpleCell *)createAccountSimpleCell:(NSIndexPath*) indexPath {
    AccountSimpleCell *cell = (AccountSimpleCell*)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier_AccountSimpleCell];
    
    NSString *title_key = [NSString stringWithFormat:@"text_account_%@", [MENU_ITEMS objectAtIndex:indexPath.row]];
    
    [cell setImage:[NSString stringWithFormat:@"account_icon_%@", [MENU_ITEMS objectAtIndex:indexPath.row]] title:NSLocalizedString(title_key, nil)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0;
    }
    
    return 0.00001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) { // all orders
                NSLog(@"GoToOrderListVC");
                [self goToOrderListVC:@""];
            }
            break;
        case 1: { //menu item
            switch (indexPath.row) {
                case AccountItemTypeReward: {
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountRewardViewController *nextVC = [AccountRewardViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }
                    break;
                }
                case AccountItemTypeCoupon: {
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountCouponViewController *nextVC = [AccountCouponViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }
                    break;
                }
                case AccountItemTypeOrder: // Orders
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        [self goToOrderListVC:@""];
                    } else {
                        [self goToLoginVC];
                    }
                    break;
                    //                case AccountItemTypeReturn: { //Return
                    //                    if ([[Customer sharedInstance] isLogged] == YES) {
                    //                        AccountReturnListViewController *nextVC = [AccountReturnListViewController new];
                    //                        nextVC.hidesBottomBarWhenPushed = YES;
                    //                        [self.navigationController pushViewController:nextVC animated:YES];
                    //                    } else {
                    //                        [self goToLoginVC];
                    //                    }
                    //
                    //                    break;
                    //                }
                case AccountItemTypeWishlist: {
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountWishlistViewController *nextVC = [AccountWishlistViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }

                    break;
                }
                case AccountItemTypeEdit:
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountEditViewController *nextVC = [AccountEditViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        nextVC.firstname = _account.fullname;
                        nextVC.email = _account.email;
                        nextVC.telephone = _account.telephone;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }
                    break;
                case AccountItemTypePassword:
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountPasswordViewController *nextVC = [AccountPasswordViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }
                    break;
                case AccountItemTypeAddress:
                    if ([[Customer sharedInstance] isLogged] == YES) {
                        AccountAddressListViewController *nextVC = [AccountAddressListViewController new];
                        nextVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:nextVC animated:YES];
                    } else {
                        [self goToLoginVC];
                    }

                    break;
            }
        }
            break;
    }
}

#pragma mark - Avatar upload actions
- (void)changeAvatar {
    if ([[Customer sharedInstance] isLogged] == NO) {
        NSLog(@"Click avatar to login...");
        [self goToLoginVC];
        return;
    }
    NSLog(@"Change avatar");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"text_change_profile_picture", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"text_cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"text_camera", nil), NSLocalizedString(@"text_photo_album", nil), nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [actionSheet removeFromSuperview];
    } else {
        _isUploadingAvatar = YES;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        if (buttonIndex == 0) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    image = [self resizeImage:image];
    
    [self uploadImage:image];
}

- (UIImage *)resizeImage:(UIImage*)sourceImage {
    CGFloat newImageWidth = 400.0;
    
    if (sourceImage.size.width <= newImageWidth || sourceImage.size.height <= newImageWidth) {
        return sourceImage;
    }
    
    CGFloat scale = newImageWidth / sourceImage.size.width;
    CGFloat newImageHeight = sourceImage.size.height * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(newImageWidth, newImageHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newImageWidth, newImageHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)uploadImage:(UIImage *)image {
    NSLog(@"Uploading image...");

    NSURL *restUrl = [NSURL URLWithString:CONFIG_API_URL];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:restUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[[Customer sharedInstance] accessToken] forHTTPHeaderField:@"access-token"];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:[NSString stringWithFormat:@"account/me/avatar?width=%ld&height=%ld", (long)AVATAR_WIDTH * 2, (long)AVATAR_WIDTH * 2] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"Avatar uploaded.");

        _isUploadingAvatar = NO;
        AccountModel *account = [[AccountModel alloc]initWithDictionary:responseObject error:nil];
        if (account) {
            _account = account;
            [[Customer sharedInstance] save:_account];
        }

        // Use new avatar
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_account.avatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _avatarImageView.image = image;

            // Save avatar image to disk
            [[SDImageCache sharedImageCache] storeImage:image forKey:_account.avatar toDisk:YES completion:nil];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _isUploadingAvatar = NO;
        //    NSLog(@"%@", error.localizedDescription);
        StatusModel *errorModel = [[StatusModel alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] error:nil];

        //    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"%@", errorModel.message);
    }];
}

#pragma mark - Redirect VC
- (void)didPressUnpaidControl {
    NSLog(@"unpaid pressed");
    [self goToOrderListVC:@"unpaid"];
}

- (void)didPressUnshippedControl {
    NSLog(@"unshipped pressed");
    [self goToOrderListVC:@"paid"];
}

- (void)didPressShippedControl {
    NSLog(@"shipped pressed");
    [self goToOrderListVC:@"shipped"];
}

- (void)didPressReviewControl {
    NSLog(@"review pressed");
    
    if ([[Customer sharedInstance] isLogged] == YES) {
        AccountUnreviewedListViewController *nextVC = [[AccountUnreviewedListViewController alloc] init];
        nextVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        [self goToLoginVC];
    }
}

- (void)didPressReturnControl {
    if ([[Customer sharedInstance] isLogged]) {
        AccountReturnListViewController *nextVC = [AccountReturnListViewController new];
        nextVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        [self goToLoginVC];
    }
}

//- (void)didPressWishlistControl {
//    if ([[Customer sharedInstance] isLogged]) {
//        AccountWishlistViewController *nextVC = [AccountWishlistViewController new];
//        nextVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:nextVC animated:YES];
//    } else {
//        [self goToLoginVC];
//    }
//}

- (void)goToSettingVC {
    AccountSettingViewController *nextVC = [AccountSettingViewController new];
    nextVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)goToLoginVC {
    if ([[Customer sharedInstance] isLogged] == NO) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate) presentLoginViewController];
    }
}

- (void)goToOrderListVC:(NSString *)orderType {
    if ([[Customer sharedInstance] isLogged] == NO) {
        [self goToLoginVC];
        return;
    }
    
    AccountOrderListViewController *nextVC = [AccountOrderListViewController new];
    nextVC.hidesBottomBarWhenPushed = YES;
    nextVC.orderListType = orderType;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - private
- (CGFloat)navbarHeight {
    if ([[System sharedInstance] isiPhoneX]) {
        return IPHONEX_NAVBAR_HEIGHT;
    }
    return NORMAL_NAVBAR_HEIGHT;
}

- (CGFloat)topViewHeight {
    if ([[System sharedInstance] isiPad]) {
        return IPAD_TOP_VIEW_HEIGHT;
    }
    return IPHONE_TOP_VIEW_HEIGHT;
}
@end
