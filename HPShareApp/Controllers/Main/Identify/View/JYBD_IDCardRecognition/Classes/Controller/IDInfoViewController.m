//
//  IDInfoViewController.m
//  IDCardRecognition
//
//  Created by tianxiuping on 2018/6/27.
//  Copyright © 2018年 XP. All rights reserved.
//

#import "IDInfoViewController.h"
#import "JYBDCardIDInfo.h"

#import "Macro.h"

#import "HPGlobalVariable.h"

#import "Masonry.h"

@interface IDInfoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic)  NSMutableArray *dataArr;
@property (strong, nonatomic)  UITableView *tableView;
@end

@implementation IDInfoViewController

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFont_Bold(18.f)];
        [_titleLabel setTextColor:COLOR_BLACK_333333];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel setText:@"身份证识别"];
        
    }
    return _titleLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(18.f));
        make.top.mas_equalTo(g_statusBarHeight + 44.f);
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.titleLabel.font.pointSize);
    }];
    
//    self.navigationItem.title = @"扫描信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, g_statusBarHeight + 44, self.view.bounds.size.width, self.view.bounds.size.height-(g_statusBarHeight + 44)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView *hearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 200)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width-30, 200)];
    imageV.image = self.IDImage;
    [hearView addSubview:imageV];
    self.tableView.tableHeaderView = hearView;
    
    if (self.IDInfo)
    {
       [self.dataArr addObject:[NSString stringWithFormat:@"卡号: %@",_IDInfo.num]];
        [self.dataArr addObject:[NSString stringWithFormat:@"姓名: %@",_IDInfo.name]];
        [self.dataArr addObject:[NSString stringWithFormat:@"性别: %@",_IDInfo.gender]];
        [self.dataArr addObject:[NSString stringWithFormat:@"民族: %@",_IDInfo.nation]];
        [self.dataArr addObject:[NSString stringWithFormat:@"地址: %@",_IDInfo.address]];
        [self.dataArr addObject:[NSString stringWithFormat:@"签发机关: %@",_IDInfo.issue]];
        [self.dataArr addObject:[NSString stringWithFormat:@"有效期: %@",_IDInfo.valid]];
    }
    
    if (self.cardInfo)
    {
        [self.dataArr addObject:[NSString stringWithFormat:@"银行卡号：%@",self.cardInfo.bankNumber]];
        [self.dataArr addObject:[NSString stringWithFormat:@"银行卡类型：%@",self.cardInfo.bankName]];
    }
    
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [self.dataArr objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
