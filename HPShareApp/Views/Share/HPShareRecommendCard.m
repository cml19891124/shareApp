//
//  HPShareRecommendCard.m
//  HPShareApp
//
//  Created by HP on 2018/11/16.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareRecommendCard.h"

@interface HPShareRecommendCard ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *tradeLabel;

@property (nonatomic, weak) UILabel *rentTimeLabel;

@property (nonatomic, weak) UILabel *areaLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *userNameLabel;

@property (nonatomic, weak) UILabel *releaseTimeLabel;

@property (nonatomic, weak) UIImageView *portrait;

@property (nonatomic, weak) UIImageView *tagIcon;

@end

@implementation HPShareRecommendCard

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
    [self setBackgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.96f]];
    [self.layer setCornerRadius:6.f];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(22.f * g_rateWidth);
        make.top.equalTo(self).with.offset(23.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *tradeDescLabel = [[UILabel alloc] init];
    [tradeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [tradeDescLabel setTextColor:COLOR_GRAY_999999];
    [tradeDescLabel setText:@"经营行业"];
    [self addSubview:tradeDescLabel];
    [tradeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(22.f * g_rateWidth);
        make.height.mas_equalTo(tradeDescLabel.font.pointSize);
        make.width.mas_equalTo(44.f);
    }];
    
    UILabel *tradeLabel = [[UILabel alloc] init];
    [tradeLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [tradeLabel setTextColor:COLOR_BLACK_333333];
    [self addSubview:tradeLabel];
    _tradeLabel = tradeLabel;
    [tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeDescLabel);
        make.top.equalTo(tradeDescLabel.mas_bottom).with.offset(12.f * g_rateWidth);
        make.height.mas_equalTo(tradeLabel.font.pointSize);
    }];
    
    CGFloat space = ((345.f - 23.f - 23.f) * g_rateWidth - 44.f * 4)/3;
    
    UILabel *rentTimeDescLabel = [[UILabel alloc] init];
    [rentTimeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [rentTimeDescLabel setTextColor:COLOR_GRAY_999999];
    [rentTimeDescLabel setText:@"可租档期"];
    [self addSubview:rentTimeDescLabel];
    [rentTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(rentTimeDescLabel.font.pointSize);
    }];
    
    UILabel *rentTimeLabel = [[UILabel alloc] init];
    [rentTimeLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [rentTimeLabel setTextColor:COLOR_BLACK_333333];
    [rentTimeLabel setText:@"不限"];
    [self addSubview:rentTimeLabel];
    _rentTimeLabel = rentTimeLabel;
    [rentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rentTimeDescLabel);
        make.centerY.equalTo(tradeLabel);
        make.height.mas_equalTo(rentTimeLabel.font.pointSize);
    }];
    
    UILabel *areaDescLabel = [[UILabel alloc] init];
    [areaDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [areaDescLabel setTextColor:COLOR_GRAY_999999];
    [areaDescLabel setText:@"期望面积"];
    [self addSubview:areaDescLabel];
    [areaDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rentTimeDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(areaDescLabel.font.pointSize);
    }];
    
    UILabel *areaLabel = [[UILabel alloc] init];
    [areaLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [areaLabel setTextColor:COLOR_RED_FF3C5E];
    [self addSubview:areaLabel];
    _areaLabel = areaLabel;
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaDescLabel);
        make.centerY.equalTo(tradeLabel);
        make.height.mas_equalTo(areaLabel.font.pointSize);
    }];
    
    UILabel *areaUnitLabel = [[UILabel alloc] init];
    [areaUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:12.f]];
    [areaUnitLabel setTextColor:COLOR_RED_FF4666];
    [areaUnitLabel setText:@"㎡"];
    [self addSubview:areaUnitLabel];
    [areaUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(areaLabel);
        make.height.mas_equalTo(areaUnitLabel.font.pointSize);
    }];
    
    UILabel *priceDescLabel = [[UILabel alloc] init];
    [priceDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [priceDescLabel setTextColor:COLOR_GRAY_999999];
    [priceDescLabel setText:@"期望价格"];
    [self addSubview:priceDescLabel];
    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(priceDescLabel.font.pointSize);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [self addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceDescLabel);
        make.centerY.equalTo(tradeLabel);
        make.height.mas_equalTo(priceLabel.font.pointSize);
    }];
    
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    [priceUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:9.f]];
    [priceUnitLabel setTextColor:COLOR_RED_FF3C5E];
    [priceUnitLabel setText:@"/天"];
    [self addSubview:priceUnitLabel];
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).with.offset(3.f);
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(priceUnitLabel.font.pointSize);
    }];
    
    UIImageView *tagIcon = [[UIImageView alloc] init];
    [self addSubview:tagIcon];
    _tagIcon = tagIcon;
    [tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(-7.f);
        make.right.equalTo(self).with.offset(-18.f);
        make.size.mas_equalTo(CGSizeMake(37.f, 50.f));
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tagIcon.mas_left).with.offset(-5.f * g_rateWidth);
    }];
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
}

- (void)setTrade:(NSString *)trade {
    [_tradeLabel setText:trade];
}

- (void)setRentTime:(NSString *)rentTime {
    [_rentTimeLabel setText:rentTime];
}

- (void)setArea:(NSString *)area {
    [_areaLabel setText:area];
}

- (void)setPrice:(NSString *)price {
    [_priceLabel setText:price];
}

- (void)setTagType:(HPShareRecommendCardType)type {
    if (type == HPShareRecommendCardTypeStartup) {
        [_tagIcon setImage:[UIImage imageNamed:@"share_startup"]];
    }
    else if (type == HPShareRecommendCardTypeOwner) {
        [_tagIcon setImage:[UIImage imageNamed:@"share_owner"]];
    }
}

@end
