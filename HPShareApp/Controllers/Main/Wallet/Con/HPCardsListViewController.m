//
//  HPCardsListViewController.m
//  HPShareApp
//
//  Created by caominglei on 2019/4/11.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPCardsListViewController.h"

#import "HPAlertSheet.h"

#import "HPUserReceiveView.h"

@interface HPCardsListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) HPUserReceiveView *unbindView;

@property (nonatomic, weak) HPAlertSheet *alertSheet;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIButton *addCardBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *cardsArray;

@property (strong, nonatomic) HPCardsInfoModel *model;
@end

@implementation HPCardsListViewController

static NSString *cardInfoCell = @"HPCardInfoCell";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCardsInfoListApi];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardsArray = [NSMutableArray array];
    
    [self.view setBackgroundColor:COLOR(61, 72, 86, 1)];
    
    [self setUpCardsSubviews];
    
    [self setUpCardsSubviewsMasonry];
    
    kWEAKSELF
    HPAlertSheet *alertSheet = [[HPAlertSheet alloc] init];
    alertSheet.separatorHeight = 3;
    alertSheet.separatorColor = COLOR_BLACK_333333;
    alertSheet.cancelTextColor = COLOR_BLACK_333333;
    alertSheet.cancelTextFont = kFont_Medium(16.f);
    alertSheet.textFont = kFont_Medium(16.f);
    alertSheet.textColor = COLOR_BLACK_333333;

    HPAlertAction *albumAction = [[HPAlertAction alloc] initWithTitle:@"解除绑定" completion:^{
        [weakSelf onClickCancelSheet:1];
    }];
    [alertSheet addAction:albumAction];
    self.alertSheet = alertSheet;

}

- (void)getCardsInfoListApi
{
    [HPHTTPSever HPPostServerWithMethod:@"/v1/bankCard/queryBankCard" paraments:@{} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [self.cardsArray removeAllObjects];
            NSArray *cardsArray = [HPCardsInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.cardsArray addObjectsFromArray:cardsArray];
            [self.tableView reloadData];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setUpCardsSubviews
{
    [self.view addSubview:self.backBtn];
    
    [self.view addSubview:self.titleLabel];
    
    [self.view addSubview:self.addCardBtn];
    
    [self.view addSubview:self.tableView];
    
}

- (void)setUpCardsSubviewsMasonry
{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.width.height.mas_equalTo(getWidth(50.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-20.f));
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(g_statusBarHeight);
        make.height.mas_equalTo(44);
    }];
    
    [self.addCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.height.mas_equalTo(getWidth(44.f));
        make.top.mas_equalTo(g_statusBarHeight);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(g_statusBarHeight + 44 + getWidth(10.f));
        make.left.right.bottom.mas_equalTo(self.view);
        
    }];
}

- (void)onClickBack:(UIButton *)UIButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:ImageNamed(@"fanhui_wh") forState:UIControlStateNormal];
        [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(18.f), getWidth(15.f), getWidth(18.f), 0)];
        [_backBtn addTarget:self action:@selector(onClickBack:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

- (UIButton *)addCardBtn
{
    if (!_addCardBtn) {
        _addCardBtn = [UIButton new];
        [_addCardBtn setImage:ImageNamed(@"xinzeng") forState:UIControlStateNormal];
        [_addCardBtn setImageEdgeInsets:UIEdgeInsetsMake(getWidth(14.f), getWidth(15.f), getWidth(14.f), getWidth(15.f))];
        [_addCardBtn addTarget:self action:@selector(onClickAddCardBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addCardBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = COLOR_GRAY_FFFFFF;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = kFont_Bold(18.f);
        _titleLabel.text = @"我的银行卡";
    }
    return _titleLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:HPCardInfoCell.class forCellReuseIdentifier:cardInfoCell];
        _tableView.separatorColor = UIColor.clearColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = COLOR(61, 72, 86, 1);
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(130.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPCardsInfoModel *model = self.cardsArray[indexPath.row];
    HPCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cardInfoCell];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _model = self.cardsArray[indexPath.row];
    [self.alertSheet show:YES];
}

- (void)onClickAddCardBtn:(UIButton *)button
{
    if (self.cardsArray.count > 3) {
        [HPProgressHUD alertMessage:@"绑定银行卡不得超过3张"];
        return;
    }
    [self pushVCByClassName:@"HPBindCardsViewController"];
}

- (void)onClickCancelSheet:(NSInteger)tag
{
    if (tag == 0) {
        [self.alertSheet show:NO];
    }else{
        [self.alertSheet show:NO];
        [self.unbindView show:YES];
    }
}

- (void)getBindCardDestoryApi
{

    [HPHTTPSever HPPostServerWithMethod:@"/v1/bankCard/unbindBankCard" paraments:@{@"shareBankCardId":self.model.shareBankCardId} needToken:YES complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            [HPProgressHUD alertMessage:MSG];
            [self.unbindView show:NO];
            [self getCardsInfoListApi];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (HPUserReceiveView *)unbindView
{
    if (!_unbindView) {
        
        kWEAKSELF
        _unbindView = [HPUserReceiveView new];
        [_unbindView.noBtn setTitle:@"暂不解除" forState:UIControlStateNormal];
        [_unbindView.okbtn setTitle:@"解除绑定" forState:UIControlStateNormal];
        _unbindView.confirmLabel.text = @"解绑后将无法使用该银行卡进行提现\n    是否确认解除绑定？";
        _unbindView.noBlock = ^{
            [weakSelf.unbindView show:NO];
        };
        
        _unbindView.okBlock = ^{
            [weakSelf getBindCardDestoryApi];
        };
    }
    return _unbindView;
}
@end
