//
//  HPLinkageSheetView.m
//  HPShareApp
//
//  Created by HP on 2018/11/14.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageSheetView.h"
#import "HPCheckTableCell.h"
#import "HPImageUtil.h"
#import "HPProgressHUD.h"

@interface HPLinkageSheetView () <UITableViewDelegate, UITableViewDataSource>

/**
 父级列表
 */
@property (nonatomic, weak) UITableView *leftTableView;

/**
 子级列表
 */
@property (nonatomic, weak) UITableView *rightTableView;

/**
 选项数据
 */
@property (nonatomic, strong) HPLinkageData *data;

/**
 选中的父类选项索引
 */
@property (nonatomic, assign) NSInteger selectedParentIndex;

/**
 选项描述Label
 */
@property (nonatomic, weak) UILabel *selectDescLabel;

/**
 选中的单选Cell
 */
@property (nonatomic, weak) HPCheckTableCell *singleCheckCell;

/**
 选中的多选Cell数组
 */
@property (nonatomic, strong) NSMutableArray *checkCells;

/**
 包含要设为单选选项的选项数组
 */
@property (nonatomic, strong) NSArray *singleTitles;

/**
 子级列表初始化选中状态的索引
 */
@property (nonatomic, assign) NSInteger selectCheckIndex;

@end

@implementation HPLinkageSheetView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithData:(HPLinkageData *)data singleTitles:(NSArray *)singleTitles allSingleCheck:(BOOL)isAllSingle {
    _data = data;
    _selectedParent = [data getParentNameAtIndex:0];
    _selectedParentIndex = 0;
    _checkItems = [[NSMutableArray alloc] init];
    _singleTitles = singleTitles;
    _maxCheckNum = 3;
    _checkCells = [[NSMutableArray alloc] init];
    _isAllSingleCheck = isAllSingle;
    _selectCheckIndex = -1;
    self = [super init];
    return self;
}

- (void)setupModalView:(UIView *)view {
    [view setBackgroundColor:UIColor.whiteColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self);
        make.height.mas_equalTo(250.f * g_rateWidth);
        make.bottom.equalTo(self);
    }];
    
    UIView *topBar = [[UIView alloc] init];
    [view addSubview:topBar];
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.width.equalTo(view);
        make.height.mas_equalTo(45.f * g_rateWidth);
    }];
    
    UILabel *selectDescLabel = [[UILabel alloc] init];
    [selectDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [selectDescLabel setTextColor:COLOR_BLACK_333333];
    [topBar addSubview:selectDescLabel];
    self.selectDescLabel = selectDescLabel;
    [selectDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBar).with.offset(21.f * g_rateWidth);
        make.centerY.equalTo(topBar);
    }];
    
    UIButton *confirmBtn = [[UIButton alloc] init];
    [confirmBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [confirmBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(onClickConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBar).with.offset(-21.f * g_rateWidth);
        make.centerY.equalTo(topBar);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_F7F7F7];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(view);
        make.top.equalTo(topBar.mas_bottom);
        make.height.mas_equalTo(2.f);
    }];
    
    UITableView *leftTableView = [[UITableView alloc] init];
    [leftTableView setBackgroundColor:COLOR_GRAY_FBFBFB];
    [leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [leftTableView setShowsVerticalScrollIndicator:NO];
    [leftTableView setDelegate:self];
    [leftTableView setDataSource:self];
    [view addSubview:leftTableView];
    self.leftTableView = leftTableView;
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(view);
        make.width.mas_equalTo(150.f * g_rateWidth);
    }];
    
    UITableView *rightTableView = [[UITableView alloc] init];
    [rightTableView setBackgroundColor:UIColor.clearColor];
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [rightTableView setDelegate:self];
    [rightTableView setDataSource:self];
    [rightTableView setShowsVerticalScrollIndicator:NO];
    [view addSubview:rightTableView];
    self.rightTableView = rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftTableView.mas_right);
        make.top.equalTo(line.mas_bottom);
        make.right.equalTo(view);
        make.bottom.equalTo(view);
    }];
}

- (void)setSelectDescription:(NSString *)desc {
    [self.selectDescLabel setText:desc];
}

- (void)onClickConfirmBtn:(UIButton *)btn {
    if (_checkItems.count == 0) {
        [HPProgressHUD alertAtBottomMessage:@"请选择子项"];
    }
    else {
        [self show:NO];
        if (self.confirmCallback) {
            _confirmCallback(_selectedParent, _checkItems, _selectedChildModel);
        }
    }
}

- (void)onTapModalOutSide {
    [self show:NO];
}

/**
 选中Cell调用的方法

 @param cell 选中的Cell
 */
- (void)selectCheckCell:(HPCheckTableCell *) cell{
    if (cell.isCheck) {
        [cell setCheck:NO];
        [self.checkItems removeObject:cell.title];
        if (cell.isSingle) {
            self.singleCheckCell = nil;
        }
        else {
            [self.checkCells removeObject:cell];
            self.selectedChildModel = nil;
        }
    }
    else {
        if (self.checkItems.count == self.maxCheckNum && !cell.isSingle) {
            [HPProgressHUD alertAtBottomMessage:[NSString stringWithFormat:@"最多选%ld个",(long)self.maxCheckNum]];
            return;
        }
        
        [cell setCheck:YES];
        NSIndexPath *indexPath = [_rightTableView indexPathForCell:cell];
        self.selectedChildModel = [_data getChildModelOfParentIndex:_selectedParentIndex atChildIndex:indexPath.row];
        
        [self.checkItems addObject:cell.title];
        if (cell.isSingle) {
            if (self.singleCheckCell) {
                [self.singleCheckCell setCheck:NO];
                [self.checkItems removeObject:self.singleCheckCell.title];
            }
            
            self.singleCheckCell = cell;
            for (HPCheckTableCell *item in _checkCells) {
                [item setCheck:NO];
                [self.checkItems removeObject:item.title];
            }
            [self.checkCells removeAllObjects];
        }
        else {
            [self.checkCells addObject:cell];
            if (self.singleCheckCell) {
                [self.singleCheckCell setCheck:NO];
                [self.checkItems removeObject:self.singleCheckCell.title];
                self.singleCheckCell = nil;
            }
        }
    }
}

/**
 清空所有选项
 */
- (void)clearCheck {
    for (HPCheckTableCell *cell in _checkCells) {
        [cell setCheck:NO];
        [self.checkItems removeObject:cell.title];
    }
    [_checkCells removeAllObjects];
    
    if (_singleCheckCell) {
        [_singleCheckCell setCheck:NO];
        [self.checkItems removeObject:_singleCheckCell.title];
        _singleCheckCell = nil;
    }
}

- (void)selectCellWithParentKey:(NSString *)pKey value:(NSString *)pValue ChildKey:(NSString *)cKey value:(NSString *)cValue {
    for (int i = 0; i < [_data getParentCount]; i ++) {
        for (int j = 0; j < [_data getChildrenCountOfParentIndex:i]; j ++) {
            NSObject *model = [_data getChildModelOfParentIndex:i atChildIndex:j];
            NSString *p_value = [model valueForKey:pKey];
            NSString *c_value = [model valueForKey:cKey];
            if ([p_value isEqualToString:pValue] && [c_value isEqualToString:cValue]) {
                [self selectCellAtParentIndex:i childIndex:j];
                return;
            }
        }
    }
}

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex{
    [self clearCheck];
    NSIndexPath *parentIndex = [NSIndexPath indexPathForRow:pIndex inSection:0];
    [self.leftTableView selectRowAtIndexPath:parentIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    _selectedParentIndex = pIndex;
    _selectedParent = [_data getParentNameAtIndex:pIndex];
    [self.rightTableView reloadData];
    
    NSIndexPath *childIndex = [NSIndexPath indexPathForRow:cIndex inSection:0];
    [self.rightTableView selectRowAtIndexPath:childIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    HPCheckTableCell *cell = [self.rightTableView cellForRowAtIndexPath:childIndex];
    if (cell) {
        [self selectCheckCell:cell];
        _selectCheckIndex = cIndex;
    }
    else {
        _selectCheckIndex = cIndex;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![cell.textLabel.text isEqualToString:_selectedParent]) {
            _selectedParent = cell.textLabel.text;
            _selectedParentIndex = indexPath.row;
            [self clearCheck];
            [_rightTableView reloadData];
        }
    }
    else {
        HPCheckTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectCheckCell:cell];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f * g_rateWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f * g_rateWidth;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:UIColor.clearColor];
            UIImage *selectedBg = [HPImageUtil getImageByColor:UIColor.clearColor inRect:CGRectMake(0, 0.f, 150.f * g_rateWidth, 40.f * g_rateWidth)];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:selectedBg]];
            [cell.textLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
            [cell.textLabel setTextColor:COLOR_BLACK_444444];
            [cell.textLabel setHighlightedTextColor:COLOR_RED_FF3C5E];
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
            [cell setIndentationWidth:26.f * g_rateWidth];
            [cell setIndentationLevel:1];
        }
        
        [cell.textLabel setText:[_data getParentNameAtIndex:indexPath.row]];
        
        return cell;
    }
    else {
        HPCheckTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        NSString *child = [_data getChildNameOfParentIndex:_selectedParentIndex atChildIndex:indexPath.row];
        
        if (cell == nil) {
            cell = [[HPCheckTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            if (_isAllSingleCheck) {
                [cell setIsSingle:YES];
            }
            else {
                if (_singleTitles) {
                    for (NSString *singleTitle in _singleTitles) {
                        if ([child isEqualToString:singleTitle]) {
                            [cell setIsSingle:YES];
                        }
                    }
                }
            }
            
            if (indexPath.row == _selectCheckIndex) {
                [cell setTitle:child];
                [self selectCheckCell:cell];
            }
        }
        
        [cell setTitle:child];
        if (cell.isCheck) {
            [cell setCheck:YES];
        }
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return [_data getParentCount];
    }
    else {
        return [_data getChildrenCountOfParentIndex:_selectedParentIndex];
    }
}

@end

