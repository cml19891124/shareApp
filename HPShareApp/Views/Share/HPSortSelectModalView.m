//
//  HPSortSelectView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSortSelectModalView.h"
#import "HPSortTableCell.h"

#define CELL_ID @"HPSortTableCell"

@interface HPSortSelectModalView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *options;

@property (nonatomic, strong) NSMutableArray *checkArray;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) HPSortTableCell *selectedCell;

@end

@implementation HPSortSelectModalView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithOptions:(NSArray *)options {
    _options = options;
    _checkArray = [[NSMutableArray alloc] init];
    for (int i =0; i < options.count; i++) {
        [_checkArray addObject:[NSNumber numberWithBool:NO]];
    }
    self = [super init];
    return self;
}

- (void)setupModalView:(UIView *)view {
    [view setBackgroundColor:COLOR_GRAY_F8F8F8];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(self);
    }];
    
    [self.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [self.layer setShadowRadius:8.f];
    [self.layer setShadowOpacity:0.2f];
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:UIColor.clearColor];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBounces:NO];
    [tableView registerClass:HPSortTableCell.class forCellReuseIdentifier:CELL_ID];
    [view addSubview:tableView];
    _tableView = tableView;
    CGFloat height = _options.count * 12.f + getWidth(_options.count * 30.f + 15.f + 13.f);
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.top.equalTo(view);
        make.height.mas_equalTo(height);
        make.bottom.equalTo(view);
    }];
}

- (void)onTapModalOutSide {
    [self show:NO];
}

- (void)selectCellAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    HPSortTableCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [cell setCheck:YES];
        _selectedCell = cell;
    }
    _selectedIndex = index;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HPSortTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_selectedCell) {
        [_selectedCell setCheck:NO];
    }
    
    [cell setCheck:YES];
    _selectedCell = cell;
    _selectedIndex = indexPath.row;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sortSelectView:didSelectAtIndex:)]) {
        [_delegate sortSelectView:self didSelectAtIndex:indexPath.row];
    }
    
//    for (HPSortTableCell *cellItem in tableView.visibleCells) {
//        if (cellItem == cell) {
//            [cellItem setCheck:YES];
//            [_checkArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
//            if (_delegate && [_delegate respondsToSelector:@selector(sortSelectView:didSelectAtIndex:)]) {
//                [_delegate sortSelectView:self didSelectAtIndex:indexPath.row];
//            }
//        }
//        else
//            [cellItem setCheck:NO];
//    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return getWidth(15.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return getWidth(13.f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 12.f + getWidth(30.f);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HPSortTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    [cell setTitle:_options[indexPath.row]];
    
    if (indexPath.row == _selectedIndex) {
        [cell setCheck:YES];
        _selectedCell = cell;
    }
    else
        [cell setCheck:NO];
    
    return cell;
}

@end
