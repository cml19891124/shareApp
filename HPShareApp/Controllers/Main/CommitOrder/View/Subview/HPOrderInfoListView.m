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

static NSString *totalFeeCell = @"HPTotalFeeCell";

- (void)setupModalView:(UIView *)view
{
    self.view = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(kScreenWidth/2);
    }];
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

    [self.footerView addSubview:self.lineView];

}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = COLOR_GRAY_F9FAFD;
    }
    return _lineView;
}

- (void)setUpOrderViewMasonry
{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self);
//        make.bottom.mas_equalTo(self);
//        make.height.mas_equalTo(getWidth(40.f) * (self.days.count + 1));
//        make.top.mas_equalTo(kScreenHeight/2);
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];

    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(50.f));
    }];
    
    [self.feeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(50.f));
        make.width.mas_equalTo(getWidth(100.f));
        make.centerX.mas_equalTo(self.headerView);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(40.f));
        make.left.width.mas_equalTo(self.tableView);
        make.top.mas_equalTo(self.mas_bottom).offset(getWidth(-40.f));
    }];
    
    [self.totalFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.footerView);
        make.height.mas_equalTo(getWidth(40.f));
        make.left.mas_equalTo(getWidth(15.f));
        make.width.mas_equalTo(getWidth(50.f));
    }];
    
    CGFloat feeW = BoundWithSize(self.feeLabel.text, kScreenWidth, 14.f).size.width + 10;
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.footerView);
        make.height.mas_equalTo(getWidth(40.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(feeW);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.footerView);
        make.height.mas_equalTo(0.5);
        
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
        _feeLabel.text = @"¥ 0.00";
        _feeLabel.textColor = COLOR_RED_EA0000;
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
//        [_tableView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, getWidth(-60.f), 0);
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:HPOrderInfoListCell.class forCellReuseIdentifier:orderInfoListCell];
    }
    return _tableView;
}

#pragma mark - uitableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.days.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return getWidth(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPOrderInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:orderInfoListCell];
    cell.dateLabel.text = [HPTimeString noPortraitLineToDateStr:self.days[indexPath.row]];
    cell.priceLabel.text = self.model?[NSString stringWithFormat:@"¥%.02f",self.model.order.totalFee.floatValue/self.days.count]:[NSString stringWithFormat:@"¥%.02f",self.dayRent.floatValue/self.days.count];
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

- (void)setModel:(HOOrderListModel *)model
{
    _model = model;
    self.days = [model.order.days componentsSeparatedByString:@","];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(40.f) * (self.days.count + 1)+getWidth(50.f));
    }];
    self.feeLabel.text = self.model.order.totalFee?[NSString stringWithFormat:@"¥%.02f",self.model.order.totalFee.floatValue]:@"--";
    [self.tableView reloadData];
}

- (void)setDays:(NSArray *)days
{
    _days = days;
    //tableView的高度
    CGFloat tbTopHeight = getWidth(40.f) * (self.days.count + 1)+getWidth(50.f);

    
    [self.view mas_updateConstraints:^(MASConstraintMaker *make) {
        if (tbTopHeight > kScreenHeight/2) {
            make.height.mas_equalTo(kScreenHeight/2);
                                    
        }else{
            make.height.mas_equalTo(tbTopHeight);
            
        }
    }];
    [self layoutIfNeeded];
    self.feeLabel.text = self.dayRent?[NSString stringWithFormat:@"¥%@",self.dayRent]:@"--";
    [self.tableView reloadData];

}
@end
