//
//  HPOrderInfoListView.m
//  HPShareApp
//
//  Created by HP on 2019/3/26.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPOrderInfoListView.h"

@implementation HPOrderInfoListView

static NSString *orderInfoListCell = @"HPOrderInfoListCell";

- (void)setupModalView:(UIView *)view
{
    [self setUpOrderView:view];

    [self setUpOrderViewMasonry];
}

- (void)setUpOrderView:(UIView *)view
{
    [view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.feeBtn];
    
    self.tableView.tableFooterView = self.footerView;
    
    [self.footerView addSubview:self.totalFeeLabel];

    [self.footerView addSubview:self.feeLabel];

}

- (void)setUpOrderViewMasonry
{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-g_bottomSafeAreaHeight + getWidth(-60.f));
        make.height.mas_equalTo(getWidth(40.f) * 5);
    }];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(50.f));
    }];
    
    [self.feeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(50.f));
        make.width.mas_equalTo(getWidth(100.f));
        make.center.mas_equalTo(self.headerView);
    }];
    
    [self.totalFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.footerView);
        make.height.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(getWidth(50.f));
    }];
    
    CGFloat feeW = BoundWithSize(self.feeLabel.text, kScreenWidth, 14.f).size.width;
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.footerView);
        make.height.mas_equalTo(getWidth(40.f));
        make.width.mas_equalTo(feeW);
    }];
}

- (HPRightImageButton *)feeBtn
{
    if (!_feeBtn) {
        _feeBtn = [HPRightImageButton new];
        _feeBtn.image = ImageNamed(@"arrow_down");
        _feeBtn.text = @"费用明细";
    }
    return _feeBtn;
}

- (UILabel *)totalFeeLabel
{
    if (!_totalFeeLabel) {
        _totalFeeLabel = [UILabel new];
        _totalFeeLabel.text = @"合计：";
        _totalFeeLabel.textColor = COLOR_GRAY_666666;
        _totalFeeLabel.textAlignment = NSTextAlignmentLeft;
        _totalFeeLabel.font = kFont_Medium(12.f);
    }
    return _totalFeeLabel;
}

- (UILabel *)feeLabel
{
    if (!_feeLabel) {
        _feeLabel = [UILabel new];
        _feeLabel.text = @"¥ 793.00";
        _feeLabel.textColor = COLOR_GRAY_666666;
        _feeLabel.textAlignment = NSTextAlignmentRight;
        _feeLabel.font = kFont_Medium(14.f);
    }
    return _feeLabel;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [UIView new];
        _footerView.backgroundColor = COLOR_GRAY_FFFFFF;
        
    }
    return _footerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = UIColor.clearColor;
        [_tableView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_tableView registerClass:HPOrderInfoListCell.class forCellReuseIdentifier:orderInfoListCell];
    }
    return _tableView;
}

#pragma mark - uitableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPOrderInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoListCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)onTapModalOutSide
{
    [self show:NO];
}
@end
