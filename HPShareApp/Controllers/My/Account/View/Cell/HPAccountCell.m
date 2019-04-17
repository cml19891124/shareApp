//
//  HPAccountCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/25.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPAccountCell.h"

@implementation HPAccountCell

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
        self.contentView.backgroundColor = COLOR_GRAY_FFFFFF;
        
        
        [self setUpAccountSubviews];
        
        [self setUpAccountSubviewsMasonry];

    }
    return self;
}

- (void)setUpAccountSubviews
{
    [self.contentView addSubview:self.icon];
    
    [self.contentView addSubview:self.titleLabel];
    
    [self.contentView addSubview:self.bindBtn];
    
}

- (void)setUpAccountSubviewsMasonry
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.width.height.mas_equalTo(getWidth(25.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    CGFloat btnW = BoundWithSize(@"去绑定", kScreenWidth, 13).size.width + 30;
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-15.f));
        make.width.mas_equalTo(btnW);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).offset(getWidth(18.f));
        make.width.mas_equalTo(kScreenWidth/3);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (UIButton *)icon
{
    if (!_icon) {
        _icon = [UIButton new];
        
    }
    return _icon;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = kFont_Medium(16.f);
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIButton *)bindBtn
{
    if (!_bindBtn) {
        _bindBtn = [UIButton new];
        [_bindBtn setTitle:@"去绑定" forState:UIControlStateNormal];
        [_bindBtn setTitle:@"已绑定" forState:UIControlStateSelected];
        [_bindBtn setTitleColor:COLOR_BLACK_333333 forState:UIControlStateNormal];
        [_bindBtn setTitleColor:COLOR_GRAY_666666 forState:UIControlStateSelected];
        _bindBtn.titleLabel.font = kFont_Medium(13.f);
        _bindBtn.backgroundColor = COLOR_GRAY_FFFFFF;
        _bindBtn.layer.cornerRadius = 4.f;
        _bindBtn.layer.masksToBounds = YES;
        _bindBtn.layer.borderColor = COLOR_BLACK_333333.CGColor;
        _bindBtn.layer.borderWidth = 1.f;
        _bindBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_bindBtn addTarget:self action:@selector(onClickBindAccountBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindBtn;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.bindBtn.backgroundColor = COLOR_GRAY_F2F2F2;
        self.bindBtn.layer.cornerRadius = 4.f;
        self.bindBtn.layer.masksToBounds = YES;
        self.bindBtn.layer.borderColor = UIColor.clearColor.CGColor;
        self.bindBtn.layer.borderWidth = 1.f;
        self.bindBtn.selected = YES;
        self.bindBtn.userInteractionEnabled = NO;
    }else{
        self.bindBtn.layer.cornerRadius = 4.f;
        self.bindBtn.layer.masksToBounds = YES;
        self.bindBtn.layer.borderColor = COLOR_BLACK_333333.CGColor;
        self.bindBtn.layer.borderWidth = 1.f;
        self.bindBtn.userInteractionEnabled = YES;
        self.bindBtn.selected = NO;

    }
}

- (void)onClickBindAccountBtn:(UIButton *)button
{
    button.selected = !button.selected;

    if (self.bindBlock) {
        self.bindBlock();
    }
}
@end
