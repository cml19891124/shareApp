//
//  JCHATPersonViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATPersonViewController.h"
#import "Macro.h"
#import "JCHATPersonInfoCell.h"
#import <JMessage/JMessage.h>
#import "JCHATChatTable.h"
#import "HPGlobalVariable.h"
#import "JCHATStringUtils.h"
//#import "JCHATChangeNameViewController.h"

@interface JCHATPersonViewController () <
TouchTableViewDelegate,
UIAlertViewDelegate,
UIGestureRecognizerDelegate,
UIPickerViewDataSource,
UIPickerViewDelegate> {
  
  JCHATChatTable *_personTabl;
  NSArray *_titleArr;
  NSArray *_imgArr;
  NSMutableArray *_infoArr;
  UIPickerView *_genderPicker;
  NSArray *_pickerDataArr;
  NSNumber *_genderNumber;
  BOOL _selectFlagGender;
}
@end


@implementation JCHATPersonViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _selectFlagGender = NO;
  HPLog(@"Action - viewDidLoad");
  _genderNumber = [NSNumber numberWithInt:1];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  self.navigationController.interactivePopGestureRecognizer.delegate = self;
  self.navigationController.navigationBar.translucent = NO;
  self.title = @"个人信息";
  [self loadUserInfoData];
  
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowColor = [UIColor colorWithRed:0 green:0.7 blue:0.8 alpha:1];
  shadow.shadowOffset = CGSizeMake(0, 0);
  
  UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [leftBtn setFrame:kNavigationLeftButtonRect];
  [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
  [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
  [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];//为导航栏添加左侧按钮
  
  _personTabl = [[JCHATChatTable alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44.f - g_statusBarHeight)];
  _personTabl.touchDelegate = self;
  _personTabl.backgroundColor = [UIColor whiteColor];
  _personTabl.scrollEnabled = NO;
  _personTabl.dataSource = self;
  _personTabl.delegate = self;
  _personTabl.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  [self.view addSubview:_personTabl];
  
  NSString *name;
  JMSGUser *user = [JMSGUser myInfo];
  if (user.nickname) {
    name = user.nickname;
  } else {
    name = user.username;
  }
  
  _genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 100)];
  _genderPicker.dataSource = self;
  _genderPicker.delegate = self;
  _genderPicker.tag = 200;
  [self.view addSubview:_genderPicker];
  
  _titleArr = @[@"昵称", @"性别", @"地区", @"个性签名"];
  _imgArr = @[@"wo_20", @"gender", @"location_21", @"signature"];
  _pickerDataArr = @[@"男", @"女"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  return [_pickerDataArr count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
  return [_pickerDataArr objectAtIndex:row];
}


#pragma mark --选择更改性别
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  if (component == 0 && row ==0) {
    _genderNumber = [NSNumber numberWithInt:1];
    _infoArr[1] = @"男";
  } else if (component == 0 && row == 1) {
    _genderNumber = [NSNumber numberWithInt:2];
    _infoArr[1] = @"女";
  } else {
    _genderNumber = [NSNumber numberWithInt:0];
  }
  
  [_personTabl reloadData];
}

- (void)showResultInfo:(id)resultObject error:(NSError *)error {
  if (error == nil) {
    JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    JMSGUser *user = [JMSGUser myInfo];
    if (user.gender == kJMSGUserGenderMale) {
      cell.personInfoConten.text = @"男";
    } else if (user.gender == kJMSGUserGenderFemale) {
      cell.personInfoConten.text = @"女";
    } else {
      cell.personInfoConten.text = @"未知";
    }
      [HPProgressHUD alertMessage:@"修改成功"];
  } else {
      [HPProgressHUD alertMessage:@"修改失败"];
  }
}

- (void)loadUserInfoData {
  _infoArr = [[NSMutableArray alloc] init];
  NSString *name;
  JMSGUser *user = [JMSGUser myInfo];
  
  if (user.nickname) {
    name = user.nickname;
  } else {
    name = user.username;
  }
  [_infoArr addObject:name];
  
  if (user.gender == kJMSGUserGenderUnknown) {
    [_infoArr addObject:@"未知"];
  } else if (user.gender == kJMSGUserGenderMale) {
    [_infoArr addObject:@"男"];
  } else {
    [_infoArr addObject:@"女"];
  }
  if (user.region) {
    [_infoArr addObject:user.region];
  } else {
    [_infoArr addObject:@""];
  }
  if (user.signature) {
    [_infoArr addObject:user.signature];
  } else {
    [_infoArr addObject:@""];
  }
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
  if (_selectFlagGender) {
     
    [JMSGUser updateMyInfoWithParameter:_genderNumber userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
      if (error == nil) {
        HPLog(@"Action updateMyInfoWithPareter success");
      } else {
        HPLog(@"Action updateMyInfoWithPareter fail");
      }
    }];
    _selectFlagGender = NO;
  }
  [self showSelectGenderView:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
  static NSString *cellIdentifier = @"JCHATPersonInfoCell";
  JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATPersonInfoCell" owner:self options:nil] lastObject];
  }
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.infoTitleLabel.text = [_titleArr objectAtIndex:indexPath.row];
  cell.personInfoConten.text = [_infoArr objectAtIndex:indexPath.row];
  cell.titleImgView.image = [UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 1) {
    _selectFlagGender = YES;
    [self showSelectGenderView:YES];
  } else {
//    JCHATChangeNameViewController *changeNameVC = [[JCHATChangeNameViewController alloc] init];
    
//    if (indexPath.row == 0) {
//      changeNameVC.updateType = kJMSGUserFieldsNickname;
//    } else if(indexPath.row == 2) {
//      changeNameVC.updateType = kJMSGUserFieldsRegion;
//    } else if(indexPath.row == 3) {
//      changeNameVC.updateType = kJMSGUserFieldsSignature;
//    }
//    [self.navigationController pushViewController:changeNameVC animated:YES];
  }
}

- (void)showSelectGenderView:(BOOL)flag {
  if (!flag) {
    [UIView animateWithDuration:0.5 animations:^{
        [self->_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height, self->_genderPicker.bounds.size.width, self->_genderPicker.bounds.size.height)];
    }];
  } else {
    [UIView animateWithDuration:0.5 animations:^{
        [self->_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height - self->_genderPicker.bounds.size.height, self->_genderPicker.bounds.size.width, self->_genderPicker.bounds.size.height)];
    }];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  JMSGUser *user = [JMSGUser myInfo];
  if (buttonIndex == 1) {
    if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
        [HPProgressHUD alertMessage:@"请输入"];
      return;
    }
    [[alertView textFieldAtIndex:0] resignFirstResponder];
    if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
        [HPProgressHUD alertWithLoadingText:@"正在修改"];
      if (alertView.tag == 0) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
              JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [self->_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.nickname;
              [HPProgressHUD alertWithFinishText:@"修改成功"];
          } else {
              [HPProgressHUD alertWithFinishText:@"修改失败"];
          }
        }];
        
      } else if (alertView.tag == 1) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          
          if (error == nil) {
              JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [self->_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            if (user.gender == kJMSGUserGenderMale) {
              cell.personInfoConten.text = @"男";
              
            } else if (user.gender == kJMSGUserGenderFemale) {
              cell.personInfoConten.text = @"女";
            } else {
              cell.personInfoConten.text = @"未知";
            }
              [HPProgressHUD alertWithFinishText:@"修改成功"];
            
          } else {
              [HPProgressHUD alertWithFinishText:@"修改失败"];
          }
        }];
      } else if (alertView.tag == 2) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
              JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [self->_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.region;
              [HPProgressHUD alertWithFinishText:@"修改成功"];
          } else {
              [HPProgressHUD alertWithFinishText:@"修改失败"];
          }
        }];
      } else if (alertView.tag == 3) {
        [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsSignature completionHandler:^(id resultObject, NSError *error) {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
          if (error == nil) {
              [HPProgressHUD alertWithFinishText:@"修改成功"];
              JCHATPersonInfoCell *cell = (JCHATPersonInfoCell *) [self->_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
            cell.personInfoConten.text = user.signature;
          } else {
              [HPProgressHUD alertWithFinishText:@"修改失败"];
          }
        }];
      }
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 3) {
    CGSize size = [JCHATStringUtils stringSizeWithWidthString:_infoArr[3] withWidthLimit:180 withFont:[UIFont systemFontOfSize:17]];
    return size.height + 36;
  }
  return 57;
}

- (void)backClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:YES];
  [self loadUserInfoData];
  [_personTabl reloadData];
  [self.navigationController setNavigationBarHidden:NO];
  // 禁用 iOS7 返回手势
  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
}


@end
