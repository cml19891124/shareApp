//
//  HPLinkageView.m
//  HPShareApp
//
//  Created by Jay on 2018/12/15.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPLinkageView.h"
#import "HPCheckTableCell.h"
#import "HPImageUtil.h"

@interface HPLinkageView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *leftTableView;

@property (nonatomic, weak) UITableView *rightTableView;

@property (nonatomic, strong) HPLinkageData *data;

@property (nonatomic, weak) HPCheckTableCell *checkCell;

@property (nonatomic, strong) NSString *selectedParent;

@property (nonatomic, assign) NSInteger selectedParentIndex;

@property (nonatomic, assign) NSInteger selectCheckIndex;


@end

@implementation HPLinkageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithData:(HPLinkageData *)data {
    self = [super init];
    if (self) {
        _data = data;
        _selectedParent = [data getParentNameAtIndex:0];
        _selectedParentIndex = 0;
        _selectCheckIndex = -1;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:COLOR_GRAY_F8F8F8];
    [self.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [self.layer setShadowRadius:8.f];
    [self.layer setShadowOpacity:0.2f];
    
    UITableView *leftTableView = [[UITableView alloc] init];
    [leftTableView setBackgroundColor:[UIColor colorWithHexString:@"#FBFBFB"]];
    [leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [leftTableView setShowsVerticalScrollIndicator:NO];
    [leftTableView setDelegate:self];
    [leftTableView setDataSource:self];
    [self addSubview:leftTableView];
    self.leftTableView = leftTableView;
    [leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(getWidth(150.f));
    }];
    
    UITableView *rightTableView = [[UITableView alloc] init];
    [rightTableView setBackgroundColor:UIColor.clearColor];
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [rightTableView setDelegate:self];
    [rightTableView setDataSource:self];
    [rightTableView setShowsVerticalScrollIndicator:NO];
    [self addSubview:rightTableView];
    self.rightTableView = rightTableView;
    [rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftTableView.mas_right);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)selectCellAtParentIndex:(NSInteger)pIndex childIndex:(NSInteger)cIndex{
    NSIndexPath *parentIndex = [NSIndexPath indexPathForRow:pIndex inSection:0];
    [self.leftTableView selectRowAtIndexPath:parentIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    _selectedParentIndex = pIndex;
    _selectedParent = [_data getParentNameAtIndex:pIndex];
    [self.rightTableView reloadData];
    
    NSIndexPath *childIndex = [NSIndexPath indexPathForRow:cIndex inSection:0];
    [self.rightTableView selectRowAtIndexPath:childIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    HPCheckTableCell *cell = [self.rightTableView cellForRowAtIndexPath:childIndex];
    if (cell) {
        [self selectCheckCell:cell];
    }
    else {
        _selectCheckIndex = cIndex;
    }
}

- (void)selectCheckCell:(HPCheckTableCell *) cell{
    [_checkCell setCheck:NO];
    [cell setCheck:YES];
    _checkCell = cell;
    
    if (_delegate && [_delegate respondsToSelector:@selector(linkageView:didSelectParentIndex:childIndex:withChildModel:)]) {
        NSObject *model = [_data getChildModelOfParentIndex:_selectedParentIndex atChildIndex:_selectCheckIndex];
        [_delegate linkageView:self didSelectParentIndex:_selectedParentIndex childIndex:_selectCheckIndex withChildModel:model];
    }
}

- (void)clearCheck {
    [_checkCell setCheck:NO];
    _checkCell = nil;
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
        _selectCheckIndex = indexPath.row;
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
