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

@interface HPLinkageView () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isInit;
}

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
        [self initView];
        [self initProperties];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_isInit) {
        _isInit = YES;
        [self setupUI];
    }
}

- (void)initView {
    [self setBackgroundColor:COLOR_GRAY_F8F8F8];
    [self.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [self.layer setShadowRadius:8.f];
    [self.layer setShadowOpacity:0.2f];
}

- (void)initProperties {
    _leftTableWidth = getWidth(150.f);
    
    _leftTableColor = [UIColor colorWithHexString:@"#FBFBFB"];
    
    _leftTextColor = UIColor.whiteColor;
    
    _leftHeaderHeight = 8.f * g_rateWidth;
    
    _leftFooterHeight = 0.f;
    
    _leftCellHeight = 40.f * g_rateWidth;
    
    _leftTextMarginLeft = 26.f * g_rateWidth;
    
    _leftTextFont = [UIFont fontWithName:FONT_MEDIUM size:16.f];
    
    _leftTextColor = COLOR_BLACK_444444;
    
    _leftTextSelectedColor = COLOR_RED_FF3C5E;
    
    _rightTableColor = UIColor.clearColor;
    
    _rightHeaderHeight = 8.f * g_rateWidth;
    
    _rightFooterHeight = 0.f;
    
    _rightCellHeight = 40.f * g_rateWidth;
    
    _rightTextMarginLeft = 47.f * g_rateWidth;
    
    _rightTextFont = [UIFont fontWithName:FONT_MEDIUM size:16.f];
    
    _rightTextColor = COLOR_BLACK_444444;
    
    _rightTextSelectedColor = COLOR_RED_FC4865;
    
    _selectedIcon = [UIImage imageNamed:@"find_shop_pair_number"];
    
    _selectedIconMarginRight = getWidth(28.f);
}

- (void)setupUI {
    UITableView *leftTableView = [[UITableView alloc] init];
    [leftTableView setBackgroundColor:_leftTableColor];
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
        make.width.mas_equalTo(self.leftTableWidth);
    }];
    
    UITableView *rightTableView = [[UITableView alloc] init];
    [rightTableView setBackgroundColor:_rightTableColor];
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
    [self.leftTableView selectRowAtIndexPath:parentIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    _selectedParentIndex = pIndex;
    _selectedParent = [_data getParentNameAtIndex:pIndex];
    [self.rightTableView reloadData];
    
    NSIndexPath *childIndex = [NSIndexPath indexPathForRow:cIndex inSection:0];
    [self.rightTableView selectRowAtIndexPath:childIndex animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
    if (tableView == _leftTableView) {
        return _leftCellHeight;
    }
    else
        return _rightCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return _leftHeaderHeight;
    }
    else
        return _rightHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _leftTableView) {
        return _leftFooterHeight;
    }
    else
        return _rightFooterHeight;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell_%ld",(long)indexPath.row];
    
    if (tableView == _leftTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setBackgroundColor:UIColor.clearColor];
            UIImage *selectedBg = [HPImageUtil getImageByColor:UIColor.clearColor inRect:CGRectMake(0.f, 0.f, _leftTableWidth, _leftCellHeight)];
            [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:selectedBg]];
            [cell.textLabel setFont:_leftTextFont];
            [cell.textLabel setTextColor:_leftTextColor];
            [cell.textLabel setHighlightedTextColor:_leftTextSelectedColor];
            [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
            [cell setIndentationWidth:_leftTextMarginLeft];
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
            [cell setTextMarginLeft:_rightTextMarginLeft];
            [cell setTextFont:_rightTextFont];
            [cell setTextColor:_rightTextColor];
            [cell setTextSelectedColor:_rightTextSelectedColor];
            [cell setSelectedIcon:_selectedIcon];
            [cell setSelectedIconMarginRight:_selectedIconMarginRight];
            
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
