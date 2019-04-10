//
//  HPHeaderViewCell.m
//  HPShareApp
//
//  Created by HP on 2019/3/20.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHeaderViewCell.h"

#import "HPSingleton.h"

#import "UIView+Corner.h"

@implementation HPHeaderViewCell

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

        self.contentView.backgroundColor = COLOR_GRAY_f9fafd;
        
        [self setUpCellSubviews];
        
        [self setUpCellSubviewsMasonry];

    }
    return self;
}

- (void)setUpCellSubviews
{
    HPLoginModel *account = [HPUserTool account];

    [self.contentView addSubview:self.bgImageView];
    
    [self.contentView addSubview:self.iconImageView];

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:account.userInfo.avatarUrl] placeholderImage:ImageNamed(@"personal_center_not_login_head")];

    [self.contentView addSubview:self.phoneBtn];

    [self.contentView addSubview:self.identifiLabel];

    [self.contentView addSubview:self.editBtn];
    
    [self.contentView addSubview:self.ownnerView];

    [self.contentView addSubview:self.userView];

    [self.contentView addSubview:self.optionalBtn];
    
    if ([HPSingleton sharedSingleton].identifyTag == 0) {
        self.ownnerView.hidden = YES;
        self.userView.hidden = NO;
    }else{
        self.ownnerView.hidden = NO;
        self.userView.hidden = YES;
    }
}

- (void)setUpCellSubviewsMasonry
{
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.top.mas_equalTo(self);
        make.height.mas_equalTo(getWidth(220.f) + g_statusBarHeight);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(getWidth(50.f));
        make.left.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(getWidth(46.f) + g_statusBarHeight);
    }];

    CGFloat phoneW = BoundWithSize(@"15817479363", kScreenWidth, 18.f).size.width + 10;
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneW);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(getWidth(11.f));
        make.top.mas_equalTo(getWidth(54.f) + g_statusBarHeight);
        make.height.mas_equalTo(self.phoneBtn.titleLabel.font.pointSize);
    }];
    
    [self.identifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/3);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(getWidth(11.f));
        make.top.mas_equalTo(self.phoneBtn.mas_bottom).offset(getWidth(9.f));
        make.height.mas_equalTo(self.identifiLabel.font.pointSize);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(getWidth(20.f));
        make.left.mas_equalTo(self.phoneBtn.mas_right).offset(getWidth(9.f));
        make.top.mas_equalTo(self.phoneBtn.mas_top).offset(g_statusBarHeight);
        make.height.mas_equalTo(getWidth(20.f));
    }];
    
    [self.optionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getWidth(50.f) + g_statusBarHeight);
        make.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(getWidth(90.f));
        make.height.mas_equalTo(getWidth(25.f));
    }];
    
    [_optionalBtn setCornerRadius:13.f addRectCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft];

    if (self.identifyTag == 0) {
        [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.right.mas_equalTo(getWidth(-15.f));
            make.height.mas_equalTo(getWidth(172.f));
        }];
    }else{
        [self.ownnerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.right.mas_equalTo(getWidth(-15.f));
            make.height.mas_equalTo(getWidth(180.f));
        }];
    }
    
}

#pragma mark - 初始化控件

- (HPOwnnerItemView *)ownnerView
{
    if (!_ownnerView) {
        _ownnerView = [HPOwnnerItemView new];
        _ownnerView.backgroundColor = UIColor.clearColor;
    }
    return _ownnerView;
}

- (HPUserHeaderView *)userView
{
    if (!_userView) {
        _userView = [HPUserHeaderView new];
        _userView.backgroundColor = UIColor.clearColor;
    }
    return _userView;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = ImageNamed(@"me_red_head");
        _bgImageView.contentMode = UIViewContentModeScaleToFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.layer.cornerRadius = getWidth(50.f)/2;
        _iconImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapHeaderView:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}

- (UIButton *)phoneBtn
{
    if (!_phoneBtn) {
        _phoneBtn = [UIButton new];
        [_phoneBtn setTitle:@"" forState:UIControlStateNormal];
        [_phoneBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(onClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn.titleLabel.font = kFont_Medium(18.f);
        _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return _phoneBtn;
}

- (UILabel *)identifiLabel
{
    if (!_identifiLabel) {
        _identifiLabel = [UILabel new];
        _identifiLabel.textColor = COLOR_GRAY_FFFFFF;
        _identifiLabel.text = @"";
        _identifiLabel.font = kFont_Medium(12.f);
        _identifiLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _identifiLabel;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton new];
        [_editBtn setBackgroundImage:ImageNamed(@"me_business_edit") forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(onClickedEditProfileInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)optionalBtn
{
    if (!_optionalBtn) {
        _optionalBtn = [UIButton new];
        [_optionalBtn setImage:ImageNamed(@"optional") forState:UIControlStateNormal];
        _optionalBtn.backgroundColor = COLOR(255, 255, 255, 0.4);
        _optionalBtn.titleLabel.font = kFont_Medium(10.f);
        [_optionalBtn setTitleColor:COLOR_GRAY_FFFFFF forState:UIControlStateNormal|UIControlStateSelected];
        [_optionalBtn addTarget:self action:@selector(onClickedOptionalBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _optionalBtn;
}

- (void)onClickedEditProfileInfo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:EditProfileInfoBtn:)]) {
        [self.delegate onClicked:self EditProfileInfoBtn:button];
    }
}

- (void)onClickedOptionalBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:OptionalBtn:)]) {
        [self.delegate onClicked:self OptionalBtn:button];
    }
}

- (void)onClickLoginBtn:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onClicked:LoginBtn:)]) {
        [self.delegate onClicked:self LoginBtn:button];
    }
}

- (void)onTapHeaderView:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(onTapped:HeaderView:)]) {
        [self.delegate onTapped:self HeaderView:tap];
    }
}

- (void)setIdentifyTag:(NSInteger)identifyTag
{
    _identifyTag = identifyTag;
        
    if (self.identifyTag == 0) {
        self.ownnerView.hidden = YES;
        self.userView.hidden = NO;
        [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.right.mas_equalTo(getWidth(-15.f));
            make.height.mas_equalTo(getWidth(172.f));
        }];
    }else{
        self.ownnerView.hidden = NO;
        self.userView.hidden = YES;
        [self.ownnerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f));
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(getWidth(30.f));
            make.right.mas_equalTo(getWidth(-15.f));
            make.height.mas_equalTo(getWidth(180.f));
        }];
    }
}

@end
