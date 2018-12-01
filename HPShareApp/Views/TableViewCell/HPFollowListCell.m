//
//  HPFollowListCell.m
//  HPShareApp
//
//  Created by HP on 2018/11/29.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPFollowListCell.h"

@interface HPFollowListCell ()

@property (nonatomic, weak) UIImageView *portraitView;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) UILabel *companyLabel;

@end

@implementation HPFollowListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImageView *portraitView = [[UIImageView alloc] init];
    [portraitView.layer setCornerRadius:28.f * g_rateWidth];
    [portraitView.layer setMasksToBounds:YES];
    [self addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15.f * g_rateWidth);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(55.f * g_rateWidth, 55.f * g_rateWidth));
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    [userNameLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
    [userNameLabel setTextColor:COLOR_BLACK_101010];
    [self addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(13.f);
        make.top.equalTo(portraitView).with.offset(9.f * g_rateWidth);
        make.height.mas_equalTo(userNameLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_LIGHT size:12.f]];
    [companyLabel setTextColor:COLOR_BLACK_101010];
    [self addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.top.equalTo(userNameLabel.mas_bottom).with.offset(10.f * g_rateWidth);
        make.height.mas_equalTo(companyLabel.font.pointSize);
        make.right.equalTo(userNameLabel);
    }];
    
    UIButton *followBtn = [[UIButton alloc] init];
    [followBtn.layer setCornerRadius:4.f];
    [followBtn setBackgroundColor:COLOR_GRAY_F2F2F2];
    [followBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [followBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    [followBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [followBtn setImage:[UIImage imageNamed:@"my_hook_icon"] forState:UIControlStateNormal];
    [followBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 2.5f, 0.f, -2.5f)];
    [followBtn setImageEdgeInsets:UIEdgeInsetsMake(0.f, -2.5f, 0.f, 2.5f)];
    [followBtn addTarget:self action:@selector(onClickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(userNameLabel);
        make.size.mas_equalTo(CGSizeMake(60.f, 25.f));
        make.left.equalTo(companyLabel.mas_right).with.offset(1.f);
    }];
    
    UIView *separator = [[UIView alloc] init];
    [separator setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self addSubview:separator];
    [separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 1.f));
    }];
}

- (void)onClickFollowBtn:(UIButton *)btn {
    if (_delegate) {
        if ([_delegate respondsToSelector:@selector(followListCell:didClickFollowBtn:)]) {
            [_delegate followListCell:self didClickFollowBtn:btn];
        }
    }
}

- (void)setPortrait:(UIImage *)image {
    [_portraitView setImage:image];
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    [_userNameLabel setText:userName];
}

- (void)setCompany:(NSString *)company {
    _company = company;
    [_companyLabel setText:company];
}

@end
