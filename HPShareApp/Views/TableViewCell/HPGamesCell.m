//
//  HPGamesCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPGamesCell.h"

@implementation HPGamesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *gamesImageArr = @[ImageNamed(@"home_page_activity1"),ImageNamed(@"home_page_activity2")];
        self.gamesImageArr = [NSMutableArray array];
        [self.gamesImageArr addObjectsFromArray:gamesImageArr];
        [self setUpGamesSubviews];
        [self setUpGamesCellSubviewsFrame];

    }
    return self;
}

- (void)setUpGamesSubviews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.fatherView];
    [self.fatherView addSubview:self.gamesLeftBtn];
    [self.fatherView addSubview:self.gamesRightBtn];
    [self.gamesLeftBtn addSubview:self.leftLabel];
    [self.gamesRightBtn addSubview:self.rightLabel];
}

- (void)setUpGamesCellSubviewsFrame
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(48.f));
        make.top.mas_equalTo(getWidth(15.f));
    }];
    
    [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(getWidth(15.f));
        make.right.mas_equalTo(self.contentView).offset(getWidth(-15.f));
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(getWidth(100.f));
    }];
    
    CGFloat imageW = getWidth(167.f);
    [self.gamesLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.fatherView);
        make.height.mas_equalTo(getWidth(100.f));
        make.width.mas_equalTo(imageW);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(getWidth(18.f));
        make.height.mas_equalTo(self.leftLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    
    [self.gamesRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(self.fatherView);
        make.height.mas_equalTo(getWidth(100.f));
        make.width.mas_equalTo(imageW);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(getWidth(18.f));
        make.height.mas_equalTo(self.rightLabel.font.pointSize);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.font = kFont_Medium(20.f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"活动专区";
    }
    return _titleLabel;
}

- (UIView *)fatherView{
    if (!_fatherView) {
        _fatherView = [UIView new];
        _fatherView.backgroundColor = COLOR_GRAY_FFFFFF;
    }
    return _fatherView;
}

- (UIButton *)gamesLeftBtn
{
    if (!_gamesLeftBtn) {
        _gamesLeftBtn = [UIButton new];
        [_gamesLeftBtn setBackgroundImage:self.gamesImageArr[0] forState:UIControlStateNormal];
        _gamesLeftBtn.tag = 110 ;
        [_gamesLeftBtn addTarget:self action:@selector(tapClickImageView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gamesLeftBtn;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.textColor = COLOR_GRAY_FFFFFF;
        _leftLabel.text = @"9.9元轻松开店";
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _leftLabel.font = kFont_Heavy(16.f);
    }
    return _leftLabel;
}

- (UIButton *)gamesRightBtn
{
    if (!_gamesRightBtn) {
        _gamesRightBtn = [UIButton new];
        [_gamesRightBtn setBackgroundImage:self.gamesImageArr[1] forState:UIControlStateNormal];;
        _gamesRightBtn.tag = 111;
        [_gamesRightBtn addTarget:self action:@selector(tapClickImageView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gamesRightBtn;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.textColor = COLOR_GRAY_FFFFFF;
        _rightLabel.text = @"店主专享好货";
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.font = kFont_Heavy(16.f);
    }
    return _rightLabel;
}

#pragma mark - 图片点击事件
- (void)tapClickImageView:(UIButton *)button
{
    if (self.tapClickImageViewBlcok) {
        self.tapClickImageViewBlcok(button.tag);
    }
}
@end
