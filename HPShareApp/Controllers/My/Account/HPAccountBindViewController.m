//
//  HPAccountBindViewController.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAccountBindViewController.h"

#import "HPGradientUtil.h"

#import "HPAccountCell.h"

@interface HPAccountBindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *navTitleView;

@property (nonatomic, strong) UILabel *titlelabel;

@property (nonatomic, strong) UIButton *colorBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *accountItemView;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation HPAccountBindViewController

static NSString *accountCell = @"HPAccountCell";


- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:COLOR_GRAY_FFFFFF];
    
//    self.navTitleView = [self setupNavigationBarWithTitle:@"账号绑定"];
    UIButton *backBtn = [UIButton new];
    [backBtn setBackgroundImage:ImageNamed(@"fanhui") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.width.height.mas_equalTo(getWidth(13.f));
        make.top.mas_equalTo(g_statusBarHeight + 15.f);
    }];
    
    self.imageArray = @[@"weixin"];//,@"QQ",@"weibo"];
    
    self.titleArray = @[@"微信"];//,@"QQ",@"微博"];
    
    [self setUpAccountSubviews];
    
    [self setUpAccountSubviewsMasonry];

}

- (void)setUpAccountSubviews
{
    [self.view addSubview:self.titlelabel];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    UIGraphicsBeginImageContextWithOptions(btnSize, NO, 0.f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [HPGradientUtil drawGradientColor:contextRef rect:CGRectMake(0.f, 0.f, btnSize.width, btnSize.height) startPoint:CGPointMake(0.f,0.f) endPoint:CGPointMake(btnSize.width, btnSize.height) options:kCGGradientDrawsBeforeStartLocation startColor:COLOR(253, 3, 3, 1) endColor:COLOR(253, 3, 3, 0)];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view addSubview:self.colorBtn];
    [_colorBtn setBackgroundImage:bgImage forState:UIControlStateNormal];

    [self.view addSubview:self.tableView];

}

- (void)setUpAccountSubviewsMasonry
{
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(g_statusBarHeight + 44.f + getWidth(30.f));
        make.left.mas_equalTo(getWidth(18.f));
        make.right.mas_equalTo(getWidth(-18.f));
        make.height.mas_equalTo(self.titlelabel.font.pointSize);
    }];
    
    CGSize btnSize = CGSizeMake(getWidth(60.f), getWidth(3.f));
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.equalTo(self.titlelabel.mas_bottom).offset(getWidth(12.f));
        make.size.mas_equalTo(btnSize);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.colorBtn.mas_bottom).offset(getWidth(33.f));
        make.height.mas_equalTo(getWidth(170.f));
    }];

}

- (UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [UILabel new];
        _titlelabel.font = kFont_Bold(18.f);
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        _titlelabel.textColor = COLOR_BLACK_333333;
        _titlelabel.text = @"第三方账号绑定";
    }
    return _titlelabel;
}

- (UIButton *)colorBtn
{
    if (!_colorBtn) {
        _colorBtn = [[UIButton alloc] init];
        [_colorBtn.layer setCornerRadius:2.f];
        [_colorBtn.layer setMasksToBounds:YES];
    }
    return _colorBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPAccountCell.class forCellReuseIdentifier:accountCell];
        _tableView.separatorColor = COLOR_GRAY_EEEEEE;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(56.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:accountCell];
    [cell.icon setBackgroundImage:ImageNamed(self.imageArray[indexPath.row]) forState:UIControlStateNormal];
    NSString *imagehl = [NSString stringWithFormat:@"%@_hl",self.imageArray[indexPath.row]];
    [cell.icon setBackgroundImage:ImageNamed(imagehl) forState:UIControlStateSelected];

    HPLoginModel *account = [HPUserTool account];
    
    if (account.extra.openid) {
        cell.icon.selected = YES;
        cell.isSelected = YES;
    }else{
        cell.icon.selected = NO;
        cell.isSelected = NO;
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    kWEAKSELF
    cell.bindBlock = ^{

        [weakSelf pushVCByClassName:@"HPThirdPartReturnController" withParam:@{@"login" : @"wx"}];
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//设置分割线的位置 在willDisplayCell上增加如下代码

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.separatorInset = UIEdgeInsetsZero;
    
}

@end
