//
//  HPSharePersonCard.m
//  HPShareApp
//
//  Created by HP on 2018/11/23.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSharePersonCard.h"

@interface HPSharePersonCard ()

@property (nonatomic, weak) UIImageView *portraitView;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) UILabel *companyLabel;

@property (nonatomic, weak) UILabel *signatureLabel;

@property (nonatomic, weak) UILabel *descLabel;

@end

@implementation HPSharePersonCard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setBackgroundColor:UIColor.whiteColor];
    [self.layer setCornerRadius:5.f];
    [self.layer setShadowColor:COLOR_GRAY_DAA6A6.CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.f, 3.f)];
    [self.layer setShadowRadius:6.f];
    [self.layer setShadowOpacity:0.2f];
    
    UIImageView *portraitView = [[UIImageView alloc] init];
    [portraitView.layer setCornerRadius:27.f * g_rateWidth];
    [portraitView.layer setMasksToBounds:YES];
    [self addSubview:portraitView];
    _portraitView = portraitView;
    [portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15.f * g_rateWidth);
        make.top.equalTo(self).with.offset(17.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(54.f * g_rateWidth, 54.f * g_rateWidth));
    }];
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    [userNameLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [userNameLabel setTextColor:COLOR_BLACK_333333];
    [self addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView.mas_right).with.offset(11.f * g_rateWidth);
        make.top.equalTo(portraitView).with.offset(11.f * g_rateWidth);
        make.height.mas_equalTo(userNameLabel.font.pointSize);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    [companyLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [companyLabel setTextColor:COLOR_BLACK_666666];
    [self addSubview:companyLabel];
    _companyLabel = companyLabel;
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.top.equalTo(userNameLabel.mas_bottom).with.offset(10.f * g_rateWidth);
    }];
    
    UIButton *followBtn = [[UIButton alloc] init];
    [followBtn.layer setCornerRadius:8.f];
    [followBtn setBackgroundColor:COLOR_RED_FF3455];
    [followBtn.titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:9.f]];
    [followBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [followBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self addSubview:followBtn];
    _followBtn = followBtn;
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userNameLabel);
        make.left.equalTo(userNameLabel.mas_right).with.offset(14.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(39.f, 15.f));
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(portraitView.mas_bottom).with.offset(16.f * g_rateWidth);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(261.f * g_rateWidth, 1.f));
    }];
    
    UIImageView *signatureIcon = [[UIImageView alloc] init];
    [signatureIcon setImage:[UIImage imageNamed:@"my_business_card_leaf"]];
    [self addSubview:signatureIcon];
    [signatureIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(portraitView);
        make.top.equalTo(line.mas_bottom).with.offset(18.f * g_rateWidth);
    }];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    [signatureLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [signatureLabel setTextColor:COLOR_BLACK_111111];
    [self addSubview:signatureLabel];
    _signatureLabel = signatureLabel;
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureIcon.mas_right).with.offset(6.f);
        make.centerY.equalTo(signatureIcon);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_REGULAR size:10.f]];
    [descLabel setTextColor:COLOR_BLACK_444444];
    [descLabel setNumberOfLines:0];
    [self addSubview:descLabel];
    _descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signatureLabel);
        make.top.equalTo(signatureIcon.mas_bottom).with.offset(13.f * g_rateWidth);
        make.width.mas_equalTo(226.f * g_rateWidth);
        make.bottom.equalTo(self).with.offset(-16.f * g_rateWidth);
    }];
}

- (void)setPortrait:(UIImage *)image {
    [_portraitView setImage:image];
}

- (void)setUserName:(NSString *)userName {
    [_userNameLabel setText:userName];
}

- (void)setCompany:(NSString *)company {
    [_companyLabel setText:company];
}

- (void)setSignature:(NSString *)signature {
    [_signatureLabel setText:signature];
}

- (void)setDescription:(NSString *)desc {
    [_descLabel setText:desc];
}

@end
