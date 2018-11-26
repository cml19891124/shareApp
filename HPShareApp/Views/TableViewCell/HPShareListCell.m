//
//  HPShareListCell.m
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareListCell.h"

@interface HPShareListCell ()

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

@implementation HPShareListCell

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
    [self setBackgroundColor:UIColor.clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView.layer setCornerRadius:7.f];
    [bgView.layer setShadowColor:COLOR_GRAY_AAAAAA.CGColor];
    [bgView.layer setShadowOffset:CGSizeMake(0.f, 2.f)];
    [bgView.layer setShadowOpacity:0.4f];
    [bgView setBackgroundColor:UIColor.whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [bgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(23.f * g_rateWidth);
        make.top.equalTo(bgView).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    UILabel *tradeDescLabel = [[UILabel alloc] init];
    [tradeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:10.f]];
    [tradeDescLabel setTextColor:COLOR_BLACK_6E7980];
    [tradeDescLabel setText:@"经营行业"];
    [bgView addSubview:tradeDescLabel];
    [tradeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(26.f);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(tradeDescLabel.font.pointSize);
    }];
    
    UILabel *tradeLabel = [[UILabel alloc] init];
    [tradeLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [tradeLabel setTextColor:COLOR_BLACK_333333];
    [bgView addSubview:tradeLabel];
    _tradeLabel = tradeLabel;
    [tradeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeDescLabel);
        make.top.equalTo(tradeDescLabel.mas_bottom).with.offset(16.f * g_rateWidth);
        make.height.mas_equalTo(tradeLabel.font.pointSize);
    }];
    
    CGFloat space = ((345.f - 26.f - 26.f) * g_rateWidth - 40.f * 4)/3;
    
    UILabel *rentTimeDescLabel = [[UILabel alloc] init];
    [rentTimeDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:10.f]];
    [rentTimeDescLabel setTextColor:COLOR_BLACK_6E7980];
    [rentTimeDescLabel setText:@"可租档期"];
    [bgView addSubview:rentTimeDescLabel];
    [rentTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tradeDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(rentTimeDescLabel.font.pointSize);
    }];
    
    UILabel *rentTimeLabel = [[UILabel alloc] init];
    [rentTimeLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [rentTimeLabel setTextColor:COLOR_BLACK_333333];
    [rentTimeLabel setText:@"不限"];
    [bgView addSubview:rentTimeLabel];
    _rentTimeLabel = rentTimeLabel;
    [rentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rentTimeDescLabel);
        make.centerY.equalTo(tradeLabel);
        make.height.mas_equalTo(rentTimeLabel.font.pointSize);
    }];
    
    UILabel *areaDescLabel = [[UILabel alloc] init];
    [areaDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:10.f]];
    [areaDescLabel setTextColor:COLOR_BLACK_6E7980];
    [areaDescLabel setText:@"期望面积"];
    [bgView addSubview:areaDescLabel];
    [areaDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rentTimeDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(areaDescLabel.font.pointSize);
    }];
    
    UILabel *areaLabel = [[UILabel alloc] init];
    [areaLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [areaLabel setTextColor:COLOR_RED_FF3C5E];
    [bgView addSubview:areaLabel];
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
    [bgView addSubview:areaUnitLabel];
    [areaUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(areaLabel);
        make.height.mas_equalTo(areaUnitLabel.font.pointSize);
    }];
    
    UILabel *priceDescLabel = [[UILabel alloc] init];
    [priceDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:10.f]];
    [priceDescLabel setTextColor:COLOR_BLACK_6E7980];
    [priceDescLabel setText:@"期望价格"];
    [bgView addSubview:priceDescLabel];
    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(areaDescLabel.mas_right).with.offset(space);
        make.centerY.equalTo(tradeDescLabel);
        make.height.mas_equalTo(priceDescLabel.font.pointSize);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_BOLD size:16.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [bgView addSubview:priceLabel];
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
    [bgView addSubview:priceUnitLabel];
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).with.offset(3.f);
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(priceUnitLabel.font.pointSize);
    }];
    
    UIImageView *tagIcon = [[UIImageView alloc] init];
    [bgView addSubview:tagIcon];
    _tagIcon = tagIcon;
    [tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(-6.f);
        make.right.equalTo(bgView).with.offset(-18.f);
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

- (void)setTagType:(HPShareListCellType)type {
    if (type == HPShareListCellTypeStartup) {
        [_tagIcon setImage:[UIImage imageNamed:@"share_startup"]];
    }
    else if (type == HPShareListCellTypeOwner) {
        [_tagIcon setImage:[UIImage imageNamed:@"share_owner"]];
    }
}

@end
