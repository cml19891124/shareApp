//
//  HPKeepController.m
//  HPShareApp
//
//  Created by HP on 2018/11/28.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPKeepController.h"
#import "HPShareListCell.h"
#import "HPImageUtil.h"
#import "HPTextDialogView.h"

#define CELL_ID @"HPShareListCell"

@interface HPKeepController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UIButton *editBtn;

@property (nonatomic, weak) UIView *bottomDeleteView;

@property (nonatomic, weak) UIButton *allCheckBtn;

@property (nonatomic, weak) HPTextDialogView *textDialogView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *checkArray;

@property (nonatomic, assign) BOOL isEdited;

@end

@implementation HPKeepController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isEdited = NO;
    
    NSArray *dataArray = @[@{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"},
                   @{@"title":@"金嘉味黄金铺位共享", @"trade":@"餐饮", @"rentTime":@"面议", @"area":@"30", @"price":@"50", @"type":@"owner"},
                   @{@"title":@"全聚德北京烤鸭店急求90家共享铺位", @"trade":@"服饰", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"startup"},
                   @{@"title":@"常德牛肉粉铺位共享", @"trade":@"餐饮", @"rentTime":@"短租", @"area":@"18", @"price":@"80", @"type":@"owner"}];
    _dataArray = [NSMutableArray arrayWithArray:dataArray];
    
    _checkArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataArray.count; i ++) {
        [_checkArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    [self setupUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:COLOR_WHITE_FCFDFF];
    UIView *navigationView = [self setupNavigationBarWithTitle:@"收藏"];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [editBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
    [editBtn setImage:[UIImage imageNamed:@"collection_edit"] forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, -20.f * g_rateWidth, 0.f, 20.f * g_rateWidth)];
    [editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, -20.f * g_rateWidth, 0.f, 20.f * g_rateWidth)];
    [navigationView addSubview:editBtn];
    _editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {\
        make.top.and.bottom.and.right.equalTo(navigationView);
        make.width.mas_equalTo(40.f);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView registerClass:HPShareListCell.class forCellReuseIdentifier:CELL_ID];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.view);
        make.top.equalTo(navigationView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChecked = ((NSNumber *)_checkArray[indexPath.row]).boolValue;
    HPShareListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setChecked:!isChecked];
    [_checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!isChecked]];
    
    for (NSNumber *boolNum in _checkArray) {
        if (boolNum.boolValue == NO) {
            [_allCheckBtn setSelected:NO];
            return;
        }
    }
    
    [_allCheckBtn setSelected:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5f * g_rateWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    NSDictionary *dict = _dataArray[indexPath.row];
    
    [cell setTitle:dict[@"title"]];
    [cell setTrade:dict[@"trade"]];
    [cell setRentTime:dict[@"rentTime"]];
    [cell setArea:dict[@"area"]];
    [cell setPrice:dict[@"price"]];
    
    if ([dict[@"type"] isEqualToString:@"startup"]) {
        [cell setTagType:HPShareListCellTypeStartup];
    }
    else if ([dict[@"type"] isEqualToString:@"owner"]) {
        [cell setTagType:HPShareListCellTypeOwner];
    }
    
    [cell setCheckEnabled:_isEdited];
    
    BOOL isChecked = ((NSNumber *)_checkArray[indexPath.row]).boolValue;
    [cell setChecked:isChecked];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - CheckCell

- (void)setAllCellChecked:(BOOL)isChecked {
    for (HPShareListCell *cell in _tableView.visibleCells) {
        [cell setChecked:isChecked];
    }
    
    for (int i = 0; i < _checkArray.count; i ++) {
        [_checkArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:isChecked]];
    }
}


#pragma mark - OnClick

- (void)onClickEditBtn:(UIButton *)btn {
    if (!_isEdited) {
        [_editBtn setImage:nil forState:UIControlStateNormal];
        [_editBtn setSelected:YES];
        _isEdited = YES;
        [_tableView reloadData];
        
        if (_bottomDeleteView == nil) {
            UIView *view = [[UIView alloc] init];
            [view.layer setShadowColor:COLOR_GRAY_AAAAAA.CGColor];
            [view.layer setShadowOffset:CGSizeMake(0.f, -2.f)];
            [view.layer setShadowRadius:12.f];
            [view.layer setShadowOpacity:0.1f];
            [view setBackgroundColor:UIColor.whiteColor];
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(- g_bottomSafeAreaHeight);
                make.left.and.width.equalTo(self.view);
                make.height.mas_equalTo(55.f * g_rateWidth);
            }];
            
            UIImage *normalImage = [HPImageUtil getRectangleByStrokeColor:COLOR_GRAY_BCC1CF fillColor:UIColor.whiteColor borderWidth:1.f cornerRadius:10.f inRect:CGRectMake(0.f, 0.f, 19.f, 19.f)];
            UIButton *allCheckBtn = [[UIButton alloc] init];
            [allCheckBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
            [allCheckBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
            [allCheckBtn setImage:normalImage forState:UIControlStateNormal];
            [allCheckBtn setImage:[UIImage imageNamed:@"collection_selection"] forState:UIControlStateSelected];
            [allCheckBtn setTitle:@"全选" forState:UIControlStateNormal];
            [allCheckBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 10.f, 0.f, -10.f)];
            [allCheckBtn addTarget:self action:@selector(onClickAllCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:allCheckBtn];
            _allCheckBtn = allCheckBtn;
            [allCheckBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).with.offset(30.f * g_rateWidth);
                make.centerY.equalTo(view);
            }];
            
            UIButton *deleteBtn = [[UIButton alloc] init];
            [deleteBtn.layer setCornerRadius:18.f];
            [deleteBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
            [deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setBackgroundColor:COLOR_RED_FF3C5E];
            [deleteBtn addTarget:self action:@selector(onClickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view).with.offset(-20.f * g_rateWidth);
                make.centerY.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(90.f, 35.f));
            }];
            
            _bottomDeleteView = view;
        }
        
        [_bottomDeleteView setHidden:NO];
    }
    else {
        [_editBtn setImage:[UIImage imageNamed:@"collection_edit"] forState:UIControlStateNormal];
        [_editBtn setSelected:NO];
        _isEdited = NO;
        [_tableView reloadData];
        
        [_bottomDeleteView setHidden:YES];
        [self setAllCellChecked:NO];
        [_allCheckBtn setSelected:NO];
    }
}

- (void)onClickAllCheckBtn:(UIButton *)btn {
    [self setAllCellChecked:!btn.isSelected];
    [btn setSelected:!btn.isSelected];
}

- (void)onClickDeleteBtn:(UIButton *)btn {
    if (_textDialogView == nil) {
        HPTextDialogView *textDialogView = [[HPTextDialogView alloc] init];
        [textDialogView setModalTop:279.f * g_rateHeight];
        [textDialogView setText:@"确定删除这些信息？"];
        __weak typeof(self) weakSelf = self;
        [textDialogView setConfirmCallback:^{
            NSMutableArray *deleteRowIndexPaths = [[NSMutableArray alloc] init];
            NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
            
            for (int i = 0; i < weakSelf.checkArray.count; i ++) {
                BOOL isChecked = ((NSNumber *)weakSelf.checkArray[i]).boolValue;
                if (isChecked) {
                    [deleteRowIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    [indexSet addIndex:i];
                }
            }
            
            [weakSelf.checkArray removeObjectsAtIndexes:indexSet];
            [weakSelf.dataArray removeObjectsAtIndexes:indexSet];
            [weakSelf.tableView deleteRowsAtIndexPaths:deleteRowIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.allCheckBtn setSelected:NO];
            }
        }];
        
        _textDialogView = textDialogView;
    }
    
    [_textDialogView show:YES];
}

@end
