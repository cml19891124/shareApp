//
//  JCHATSelectFriendsCtl.m
//  JPush IM
//
//  Created by Apple on 15/2/6.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATSelectFriendsCtl.h"
//#import "JChatConstants.h"
#import "JCHATSelectFriendCell.h"
//#import "JCHATConversationViewController.h"
#import "Macro.h"
#import <JMessage/JMessage.h>
#define kheadViewFrame CGRectMake(0, 0, kScreenWidth, 60)
#define kgroupNameLabelFrame CGRectMake(0, 5, 60, 50)
#define kgroupTextFieldFrame CGRectMake(60, 5, 150, 50)
#define kselectFriendTabFrame CGRectMake(0, 0, kScreenWidth, kScreenHeight)
#define kHeadViewFrame CGRectMake((kScreenWidth - 70)/2, (150-70)/2, 70, 70)
#define kbaseLineFrame CGRectMake(0, 59, kScreenWidth, 0.5)
#define kselectFriendTabFrame CGRectMake(0, 0, kScreenWidth, kScreenHeight)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)
#define kCreatGroupState  @"creatGroupState"

static const NSInteger tablecellHeight = 64;

@interface JCHATSelectFriendsCtl ()
{
  UITextField *_groupTextField;
}
@end

@implementation JCHATSelectFriendsCtl

- (void)viewDidLoad {
  [super viewDidLoad];
  HPLog(@"Action - viewDidLoad");
  [self sectionIndexTitles];
  UIView *headView =[[UIView alloc]initWithFrame:kheadViewFrame];
  [headView setBackgroundColor:[UIColor whiteColor]];
  self.title = @"创建群聊";
  UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:kgroupNameLabelFrame];
  groupNameLabel.text = @"群名称:";
  groupNameLabel.textAlignment = NSTextAlignmentCenter;
  [headView addSubview:groupNameLabel];
  
  _groupTextField =[[UITextField alloc] initWithFrame:kgroupTextFieldFrame];
  [headView addSubview:_groupTextField];
  _groupTextField.placeholder = @"请输入群名称";
  
  UIView *line = [[UIView alloc]initWithFrame:kbaseLineFrame];
  [line setBackgroundColor:COLOR_GRAY_BBBBBB];
  [headView addSubview:line];
  
  self.selectFriendTab =[[JCHATChatTable alloc] initWithFrame:kselectFriendTabFrame style:UITableViewStylePlain];
  [self.selectFriendTab setBackgroundColor:[UIColor clearColor]];
  self.selectFriendTab.dataSource=self;
  self.selectFriendTab.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.selectFriendTab.delegate=self;
  self.selectFriendTab.touchDelegate = self;
  self.selectFriendTab.tableHeaderView=headView;
  self.selectFriendTab.delegate = self;
  [self.view addSubview:self.selectFriendTab];
  
  [self setupNavigationBar];
}

- (void)setupNavigationBar {
  UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加右侧按钮
  
  UIButton *rightbtn =[UIButton buttonWithType:UIButtonTypeCustom];
  [rightbtn setFrame:CGRectMake(0, 0, 50, 50)];
  [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
  [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];//为导航栏添加右侧按钮
  self.navigationController.navigationBar.translucent = NO;
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event
{
  [_groupTextField resignFirstResponder];
}

- (void)rightBtnClick {
  if ([_groupTextField.text isEqualToString:@""]) {
      [HPProgressHUD alertMessage:@"请输入群名称！"];
    return;
  }
    [_groupTextField resignFirstResponder];
    [HPProgressHUD alertMessage:@"正在创建群组！"];

  [JMSGGroup createGroupWithName:_groupTextField.text desc:@"" memberArray:nil completionHandler:^(id resultObject, NSError *error) {
      [HPProgressHUD alertMessage:@"创建群组成功！"];
    if (error ==nil) {
      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:kCreatGroupState object:resultObject];
    } else if (error.code == 808003) {
        [HPProgressHUD alertMessage:@"创建群组数量达到上限！"];

    } else {
        [HPProgressHUD alertMessage:@"创建群组失败！"];
    }
  }];
}

- (void)backClick {
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sectionIndexTitles {
  self.arrayOfCharacters =[[NSMutableArray alloc] init];
  for(char c = 'A';c<='Z';c++)
    [self.arrayOfCharacters addObject:[NSString stringWithFormat:@"%c",c]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  NSInteger count = 0;
  for(NSString *character in self.arrayOfCharacters)
  {
    if([character isEqualToString:title])
    {
      return count;
    }
    count ++;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier =@"selectFriendIdentify";
  JCHATSelectFriendCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (!cell) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATSelectFriendCell" owner:self options:nil] lastObject];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return tablecellHeight;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
