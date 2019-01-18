//
//  AddressBookController1.m
//  PPGetAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "HPAddressBookViewController.h"
#import "PPGetAddressBook.h"
#import "HPContactsInfoCell.h"
#import "UIImageView+WebCache.h"
#import <Contacts/Contacts.h>
#import "UITableView+ZYXIndexTip.h"

#define RGBColor(r, g, b)       [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define START NSDate *startTime = [NSDate date]
#define END NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
#define imageName(name)      [UIImage imageNamed:name]

@interface HPAddressBookViewController ()<HPContactsInfoCellDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation HPAddressBookViewController
static NSString *contactsInfoCell = @"contactsInfoCell";
-(void)pop:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"通讯录";
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:imageName(@"back") forState:UIControlStateNormal];
    [leftbtn addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftitem = [[UIBarButtonItem alloc] initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem = leftitem;
    self.tableView.tableFooterView = [UIView new];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0, 0, 80, 80);
    indicator.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.height*0.5-80);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    self.tableView.sectionIndexColor = RGBColor(155, 155, 155);//修改右边索引字体的颜色

    [self.tableView registerNib:[UINib nibWithNibName:@"HPContactsInfoCell" bundle:nil] forCellReuseIdentifier:contactsInfoCell];

    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        
        [indicator stopAnimating];
        
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = nameKeys;
        
        [self.tableView reloadData];
    } authorizationFailure:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录"
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        alert.tag = 110;
        [alert show];
    }];
    
    self.tableView.rowHeight = 60;
    
    [self.tableView addIndexTip];

}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

#pragma mark - TableViewDatasouce/TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _keys[section];
    return [_contactPeopleDict[key] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPContactsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:contactsInfoCell];
    if (!cell)
    {
        cell = [[HPContactsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactsInfoCell];
    }
    
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    cell.userName.text = people.name;
    
//    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1162420077,2400402049&fm=200&gp=0.jpg"] placeholderImage:imageName(@"未标题-4-3")];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    return cell;
}
- (void)selectChooseInviteSomebody
{
    NSLog(@"invite");

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:people.name
                                                    message:[NSString stringWithFormat:@"号码:%@",people.mobileArray]
                                                   delegate:nil
                                          cancelButtonTitle:@"知道啦"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark 自定义索引视图 回调处理，滚动到对应组
-(void)tableViewSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    if(self.keys.count <= indexPath.row){
        return;
    }
    if( 0 == indexPath.section){
        CGPoint offset =  self.tableView.contentOffset;
        offset.y = -self.tableView.contentInset.top;
        self.tableView.contentOffset = offset;
    }else{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
@end
