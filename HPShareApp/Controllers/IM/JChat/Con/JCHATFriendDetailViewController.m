//
//  JCHATFriendDetailViewController.m
//  极光IM
//
//  Created by Apple on 15/4/7.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATFriendDetailViewController.h"
#import "JCHATPersonInfoCell.h"
//#import "JChatConstants.h"
#import "JCHATFrIendDetailMessgeCell.h"
//#import "JCHATConversationViewController.h"
#import "JCHATSetDisturbTableViewCell.h"
#import "AppDelegate.h"
#import "Macro.h"

#define kSeparateLineFrame CGRectMake(0, 150-0.5,kScreenWidth, 0.5)
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kSeparateLineColor UIColorFromRGB(0xd0d0cf)
#define kHeadViewFrame CGRectMake((kScreenWidth - 70)/2, (150-70)/2, 70, 70)
#define kNameLabelFrame CGRectMake(0, 150-40, kScreenWidth, 40)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)

@interface JCHATFriendDetailViewController () {
  NSArray *_titleArr;
  NSArray *_imgArr;
  NSMutableArray *_infoArr;
  UILabel *_nameLabel;
  UIImageView *_headView;
}
@end

@implementation JCHATFriendDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  HPLog(@"Action - viewDidLoad");
  
  _detailTableView.dataSource = self;
  _detailTableView.delegate = self;
  [_detailTableView setBackgroundColor:[UIColor clearColor]];
  _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.detailTableView.frame.size.width, 150)];
  [tableHeadView setBackgroundColor:[UIColor whiteColor]];
  _detailTableView.tableHeaderView = tableHeadView;
  UILabel *separateline =[[UILabel alloc] initWithFrame:kSeparateLineFrame];
  [separateline setBackgroundColor:kSeparateLineColor];
  [tableHeadView addSubview:separateline];
  
  _headView =[[UIImageView alloc] initWithFrame:kHeadViewFrame];
  _headView.layer.cornerRadius = _headView.frame.size.height/2;
  [_headView.layer setMasksToBounds:YES];
  [_headView setBackgroundColor:[UIColor clearColor]];
  [_headView setContentMode:UIViewContentModeScaleAspectFit];
  [_headView.layer setMasksToBounds:YES];
  [tableHeadView addSubview:_headView];
  
  _nameLabel = [[UILabel alloc]initWithFrame:kNameLabelFrame];
  _nameLabel.textColor = [UIColor blackColor];
  _nameLabel.font = [UIFont boldSystemFontOfSize:18];
  _nameLabel.textAlignment =NSTextAlignmentCenter;
  [tableHeadView addSubview:_nameLabel];
  [self setupNavigation];
  [self loadUserInfoData];
}

- (void)setupNavigation {
  self.title = @"详细资料";
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  self.navigationController.navigationBar.translucent = NO;
}

- (void)loadUserInfoData {
  _titleArr = @[@"性别",@"地区",@"个性签名"];
  _imgArr = @[@"gender",@"location_21",@"signature"];
  _infoArr = [[NSMutableArray alloc]init];
    [HPProgressHUD alertMessage:@"正在加载！"];
  kWEAKSELF
  
  [JMSGUser userInfoArrayWithUsernameArray:@[self.userInfo.username] appKey:JPushAppKey
                         completionHandler:^(id resultObject, NSError *error) {
                           __strong __typeof(weakSelf) strongSelf = weakSelf;
                           [HPProgressHUD alertMessage:@"加载完成！"];
                           
                           if (error) {
                             [_headView setImage:[UIImage imageNamed:@"headDefalt"]];
                               [HPProgressHUD alertMessage:@"获取数据失败！"];

                             return;
                           }
                           JMSGUser *user = resultObject[0];
                           [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
                             if (error == nil) {
                               
                               if (data != nil) {
                                   [self->_headView setImage:[UIImage imageWithData:data]];
                               } else {
                                   [self->_headView setImage:[UIImage imageNamed:@"headDefalt"]];
                               }
                               
                             } else {
                               HPLog(@"JCHATFriendDetailVC  thumbAvatarData fail");
                             }
                           }];
                           
                           if (user.nickname) {
                               self->_nameLabel.text = user.nickname;
                           } else {
                               self->_nameLabel.text = user.username;
                           }
                           
                           if (user.gender == kJMSGUserGenderUnknown) {
                               [self->_infoArr addObject:@"未知"];
                           } else if (user.gender == kJMSGUserGenderMale) {
                               [self->_infoArr addObject:@"男"];
                           } else {
                               [self->_infoArr addObject:@"女"];
                           }
                           
                           if (user.region) {
                               [self->_infoArr addObject:user.region];
                           } else {
                               [self->_infoArr addObject:@""];
                           }
                           
                           if (user.signature) {
                               [self->_infoArr addObject:user.signature];
                           } else {
                               [self->_infoArr addObject:@""];
                           }
                           
                           [strongSelf.detailTableView reloadData];
                         }];
  
}

- (void)switchDisturb {
    [HPProgressHUD alertMessage:@"正在修改免打扰"];
    kWEAKSELF
  [self.userInfo setIsNoDisturb:!self.userInfo.isNoDisturb handler:^(id resultObject, NSError *error) {
    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    if (error == nil) {
    }
  }];
}

- (void)switchBlack {
    [HUD HUDNotHidden:@"正在修改黑名单"];
//  BOOL isbool = self.userInfo.isInBlacklist;
  if (self.userInfo.isInBlacklist) {

    [JMSGUser delUsersFromBlacklist:@[self.userInfo.username] appKey:JPushAppKey
                  completionHandler:^(id resultObject, NSError *error) {
                      [HUD HUDHidden];
                      [HUD HUDWithString:@"操作成功！" Delay:1.0];
                    if (error != nil) {
                        [HUD HUDHidden];
                        [HUD HUDWithString:@"取消用户黑名单状态失败！" Delay:1.0];
                      return;
                    }
                  }];
  } else {
    [JMSGUser addUsersToBlacklist:@[self.userInfo.username] appKey:JPushAppKey
                completionHandler:^(id resultObject, NSError *error) {
                    [HUD HUDHidden];
                    [HUD HUDWithString:@"操作成功！" Delay:1.0];
                  if (error != nil) {
                      [HUD HUDHidden];
                      [HUD HUDWithString:@"添加该用户到黑名单失败！" Delay:1.0];
                    return;
                  }
                }];

  }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_titleArr count] + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if (indexPath.row == 5) {
    static NSString *cellIdentifier = @"JCHATFrIendDetailMessgeCell";
    JCHATFrIendDetailMessgeCell *cell = (JCHATFrIendDetailMessgeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATFrIendDetailMessgeCell" owner:self options:nil] lastObject];
    }
    
    cell.skipToSendMessage = self;
    return cell;
  }
  
  if (indexPath.row == 3) {
    static NSString *cellIdentifier = @"JCHATSetDisturbTableViewCell";
    JCHATSetDisturbTableViewCell *cell = (JCHATSetDisturbTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSetDisturbTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.delegate = self;
    [cell layoutToSetDisturb:self.userInfo.isNoDisturb];
    return cell;
  }
  
  if (indexPath.row == 4) {
    static NSString *cellIdentifier = @"JCHATSetDisturbTableViewCell";
    JCHATSetDisturbTableViewCell *cell = (JCHATSetDisturbTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSetDisturbTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.delegate = self;

    [cell layoutToSetBlack:self.userInfo.isInBlacklist];
    return cell;
  }
  
  static NSString *cellIdentifier = @"JCHATPersonInfoCell";
  JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATPersonInfoCell" owner:self options:nil] lastObject];
  }
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.infoTitleLabel.text=[_titleArr objectAtIndex:indexPath.row];
  if ([_infoArr count] >0) {
    cell.personInfoConten.text=[_infoArr objectAtIndex:indexPath.row];
  }
  cell.arrowImg.hidden = YES;
  cell.titleImgView.image=[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
  return cell;
  
}

- (void)skipToSendMessage {
//  for (UIViewController *ctl in self.navigationController.childViewControllers) {
//    if ([ctl isKindOfClass:[JCHATConversationViewController class]]) {
//
//      if (self.isGroupFlag) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSkipToSingleChatViewState object:_userInfo];
//      } else {
//        [self.navigationController popToViewController:ctl animated:YES];
//      }
//    }
//  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    return 80;
  }
  return 57;
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
  
}

@end
