//
//  HPShareListCell.m
//  HPShareApp
//
//  Created by HP on 2018/11/17.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareListCell.h"
#import "HPImageUtil.h"
#import "HPCommonData.h"

@interface HPShareListCell ()

@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *tradeDescLabel;

@property (nonatomic, weak) UILabel *rentTimeDescLabel;

@property (nonatomic, weak) UILabel *areaDescLabel;

@property (nonatomic, weak) UILabel *priceDescLabel;

@property (nonatomic, weak) UILabel *tradeLabel;

@property (nonatomic, weak) UILabel *rentTimeLabel;

@property (nonatomic, weak) UILabel *areaLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *priceUnitLabel;

@property (nonatomic, weak) UIImageView *tagIcon;

@property (nonatomic, weak) UIButton *checkBtn;

@property (nonatomic, weak) MASConstraint *leftConstraint;

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
    [bgView.layer setShadowRadius:8.f];
    [bgView.layer setShadowOpacity:0.4f];
    [bgView setBackgroundColor:UIColor.whiteColor];
    [self addSubview:bgView];
    _bgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 115.f * g_rateWidth));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(getWidth(11.f));
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(getWidth(93.f), getWidth(93.f)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setNumberOfLines:0];
    [bgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView).with.offset(12.f * g_rateWidth);
        make.top.equalTo(imageView);
    }];
    
    UILabel *priceDescLabel = [[UILabel alloc] init];
    [priceDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [priceDescLabel setTextColor:COLOR_GRAY_999999];
    [priceDescLabel setText:@"期望价格"];
    [bgView addSubview:priceDescLabel];
    _priceDescLabel = priceDescLabel;
//    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(areaDescLabel.mas_right).with.offset(space);
//        make.centerY.equalTo(tradeDescLabel);
//        make.height.mas_equalTo(priceDescLabel.font.pointSize);
//    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_BOLD size:15.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [bgView addSubview:priceLabel];
    _priceLabel = priceLabel;
//    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(priceDescLabel);
//        make.centerY.equalTo(tradeLabel);
//        make.height.mas_equalTo(priceLabel.font.pointSize);
//    }];
    
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    [priceUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:9.f]];
    [priceUnitLabel setTextColor:COLOR_RED_FF3C5E];
    [priceUnitLabel setText:@"元/天"];
    [bgView addSubview:priceUnitLabel];
    _priceUnitLabel = priceUnitLabel;
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).with.offset(3.f);
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(priceUnitLabel.font.pointSize);
    }];
    
    UIImageView *tagIcon = [[UIImageView alloc] init];
    [bgView addSubview:tagIcon];
    _tagIcon = tagIcon;
    [tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(-7.f);
        make.right.equalTo(bgView).with.offset(-18.f);
        make.size.mas_equalTo(CGSizeMake(37.f, 50.f));
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tagIcon.mas_left).with.offset(-5.f * g_rateWidth);
    }];
    
    UIImage *normalImage = [HPImageUtil getRectangleByStrokeColor:COLOR_GRAY_BCC1CF fillColor:UIColor.whiteColor borderWidth:1.f cornerRadius:10.f inRect:CGRectMake(0.f, 0.f, 19.f, 19.f)];
    
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setImage:normalImage forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"collection_selection"] forState:UIControlStateSelected];
    [bgView addSubview:checkBtn];
    _checkBtn = checkBtn;
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(15.f * g_rateWidth);
        make.top.equalTo(bgView).with.offset(20.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(19.f, 19.f));
    }];
    [checkBtn setHidden:YES];
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
    switch (type) {
        case HPShareListCellTypeOwner:
            [_tagIcon setImage:ImageNamed(@"share_owner")];
            break;
            
        case HPShareListCellTypeStartup:
            [_tagIcon setImage:ImageNamed(@"share_startup")];
            break;
            
        default:
            break;
    }
}

- (void)setUnitType:(HPSharePriceUnitType)type {
    switch (type) {
        case HPSharePriceUnitTypeHour:
            [_priceUnitLabel setText:@"元/小时"];
            break;
            
        case HPSharePriceUnitTypeDay:
            [_priceUnitLabel setText:@"元/天"];
            break;
            
        default:
            break;
    }
}

- (void)setModel:(HPShareListModel *)model {
    _model = model;
    NSString *title = model.title;
    NSString *trade = [HPCommonData getIndustryNameById:model.industryId];
    
    NSString *shareDayStr = model.shareDays;
    NSArray *shareDays = [shareDayStr componentsSeparatedByString:@","];
    NSString *rentTime = [NSString stringWithFormat:@"%lu", (unsigned long)shareDays.count];
    if ([rentTime isEqualToString:@"0"]) {
        rentTime = @"面议";
    }
    else {
        rentTime = [rentTime stringByAppendingString:@" 天"];
    }
    
    NSString *area = model.area;
    NSString *price = model.rent;
    NSInteger tagType = model.type;
    NSInteger unitType = model.rentType;
    
    [self setTitle:title];
    [self setTrade:trade];
    [self setRentTime:rentTime];
    [self setArea:area];
    [self setPrice:price];
    [self setTagType:tagType];
    [self setUnitType:unitType];
}

- (void)setCheckEnabled:(BOOL)enabled {
    if (enabled) {
        [_checkBtn setHidden:NO];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.leftConstraint uninstall];
            self.leftConstraint = make.left.equalTo(self.checkBtn.mas_right).with.offset(10.f * g_rateWidth);
        }];
        
        CGFloat space = ((345.f - 44.f - 17.f) * g_rateWidth - 44.f * 4)/3;
        
        [_rentTimeDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tradeDescLabel.mas_right).with.offset(space);
        }];
        
        [_areaDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rentTimeDescLabel.mas_right).with.offset(space);
        }];
        
        [_priceDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.areaDescLabel.mas_right).with.offset(space);
        }];
    }
    else {
        [_checkBtn setHidden:YES];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            [self.leftConstraint uninstall];
            self.leftConstraint = make.left.equalTo(self.bgView).with.offset(23.f * g_rateWidth);
        }];
        
        CGFloat space = ((345.f - 23.f - 23.f) * g_rateWidth - 44.f * 4)/3;
        
        [_rentTimeDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tradeDescLabel.mas_right).with.offset(space);
        }];
        
        [_areaDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rentTimeDescLabel.mas_right).with.offset(space);
        }];
        
        [_priceDescLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.areaDescLabel.mas_right).with.offset(space);
        }];
    }
}

- (void)setChecked:(BOOL)isChecked {
    [_checkBtn setSelected:isChecked];
    _isChecked = isChecked;
}

@end
