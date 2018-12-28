//
//  HPShareManageCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/4.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPShareManageCell.h"
#import "HPTagView.h"

@interface HPShareManageCell ()

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *priceDescLabel;

@property (nonatomic, weak) UILabel *priceLabel;

@property (nonatomic, weak) UILabel *priceUnitLabel;

@property (nonatomic, weak) UIImageView *typeIcon;

@property (nonatomic, strong) NSMutableArray *tagItems;

@property (nonatomic, weak) UIImageView *photoView;

@property (nonatomic, weak) UILabel *releaseTimeLabel;

@end

@implementation HPShareManageCell

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
        _tagItems = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tagItems = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView.layer setCornerRadius:7.f];
    [bgView.layer setShadowColor:COLOR_GRAY_AAAAAA.CGColor];
    [bgView.layer setShadowOffset:CGSizeMake(0.f, 2.f)];
    [bgView.layer setShadowRadius:8.f];
    [bgView.layer setShadowOpacity:0.4f];
    [bgView setBackgroundColor:UIColor.whiteColor];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 161.f * g_rateWidth));
    }];
    
    UIImageView *photoView = [[UIImageView alloc] init];
    [photoView setBackgroundColor:COLOR_GRAY_F6F6F6];
    [photoView setContentMode:UIViewContentModeScaleAspectFill];
    [photoView.layer setMasksToBounds:YES];
    [bgView addSubview:photoView];
    _photoView = photoView;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).with.offset(getWidth(11.f));
        make.top.equalTo(bgView).with.offset(getWidth(11.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(93.f), getWidth(93.f)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:14.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setNumberOfLines:0];
    [bgView addSubview:titleLabel];
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(photoView.mas_right).with.offset(12.f * g_rateWidth);
        make.top.equalTo(photoView);
    }];
    
    for (int i = 0; i < 3; i ++) {
        HPTagView *tagView = [[HPTagView alloc] init];
        [bgView addSubview:tagView];
        [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(titleLabel);
                make.top.equalTo(titleLabel.mas_bottom).with.offset(9.f * g_rateWidth);
            }
            else {
                UIView *lastTagItem = self.tagItems[i - 1];
                make.left.equalTo(lastTagItem.mas_right).with.offset(5.f);
                make.centerY.equalTo(lastTagItem);
            }
        }];
        [tagView setHidden:YES];
        
        [_tagItems addObject:tagView];
    }
    
    UILabel *priceDescLabel = [[UILabel alloc] init];
    [priceDescLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:11.f]];
    [priceDescLabel setTextColor:COLOR_GRAY_999999];
    [priceDescLabel setText:@"共享价格"];
    [bgView addSubview:priceDescLabel];
    _priceDescLabel = priceDescLabel;
    [priceDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(photoView).with.offset(-getWidth(4.f));
        make.height.mas_equalTo(priceDescLabel.font.pointSize);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [priceLabel setTextColor:COLOR_RED_FF3C5E];
    [bgView addSubview:priceLabel];
    _priceLabel = priceLabel;
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceDescLabel.mas_right).with.offset(getWidth(10.f));
        make.bottom.equalTo(priceDescLabel);
        make.height.mas_equalTo(priceLabel.font.pointSize);
    }];
    
    UILabel *priceUnitLabel = [[UILabel alloc] init];
    [priceUnitLabel setFont:[UIFont fontWithName:FONT_BOLD size:9.f]];
    [priceUnitLabel setTextColor:COLOR_RED_FF3C5E];
    [priceUnitLabel setText:@"/天"];
    [bgView addSubview:priceUnitLabel];
    _priceUnitLabel = priceUnitLabel;
    [priceUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(priceLabel);
        make.height.mas_equalTo(priceUnitLabel.font.pointSize);
    }];
    
    UIImageView *typeIcon = [[UIImageView alloc] init];
    [bgView addSubview:typeIcon];
    _typeIcon = typeIcon;
    [typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(-7.f);
        make.left.equalTo(bgView.mas_right).with.offset(-55.f);
        make.size.mas_equalTo(CGSizeMake(37.f, 50.f));
    }];
    
    [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(typeIcon.mas_left).with.offset(-10.f * g_rateWidth);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_F4F4F4];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).with.offset(15.f * g_rateWidth);
        make.centerX.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(304.f * g_rateWidth, 1.f));
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [bgView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.and.width.and.bottom.equalTo(bgView);
    }];
    [self setupBottomView:bottomView];
}

- (void)setupBottomView:(UIView *)view {
    UIImageView *timeIcon = [[UIImageView alloc] init];
    [timeIcon setImage:[UIImage imageNamed:@"shared_shop_details_time"]];
    [view addSubview:timeIcon];
    [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(23.f * g_rateWidth);
        make.centerY.equalTo(view);
    }];
    
    UILabel *releaseTimeLabel = [[UILabel alloc] init];
    [releaseTimeLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12.f]];
    [releaseTimeLabel setTextColor:COLOR_GRAY_999999];
    [view addSubview:releaseTimeLabel];
    _releaseTimeLabel = releaseTimeLabel;
    [releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeIcon.mas_right).with.offset(8.f);
        make.centerY.equalTo(view);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn.layer setBorderWidth:1.f];
    [editBtn.layer setBorderColor:COLOR_RED_FF3C5E.CGColor];
    [editBtn.layer setCornerRadius:5.f];
    [editBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [editBtn setTitleColor:COLOR_RED_FF3C5E forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [view addSubview:editBtn];
    _editBtn = editBtn;
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-18.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(65.f * g_rateWidth, 27.f * g_rateWidth));
    }];
    
    UIButton *deleteBtn = [[UIButton alloc] init];
    [deleteBtn.layer setBorderWidth:1.f];
    [deleteBtn.layer setBorderColor:COLOR_GRAY_DDDDDD.CGColor];
    [deleteBtn.layer setCornerRadius:5.f];
    [deleteBtn.titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
    [deleteBtn setTitleColor:COLOR_BLACK_6E7980 forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [view addSubview:deleteBtn];
    _deleteBtn = deleteBtn;
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(editBtn.mas_left).with.offset(-10.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(65.f * g_rateWidth, 27.f * g_rateWidth));
    }];
}

- (void)setModel:(HPShareListModel *)model {
    _model = model;
    NSString *title = model.title;
    NSString *price = model.rent;
    NSInteger type = model.type;
    NSInteger unitType = model.rentType;
    NSString *tagStr = model.tag;
    NSArray *tags;
    if (tagStr) {
        tags = [tagStr componentsSeparatedByString:@","];
    }
    NSString *photoUrl;
    if (model.picture) {
        photoUrl = model.picture.url;
    }
    else {
        HPLog(@"+++++++++ NO Picture");
    }
    
    [self setTitle:title];
    [self setPrice:price];
    [self setType:type];
    [self setUnitType:unitType];
    [self setReleaseTime:model.createTime];
    if (tags) {
        [self setTags:tags];
    }
    if (photoUrl) {
        [self setPhotoUrl:photoUrl];
    }
}

- (void)setTitle:(NSString *)title {
    [_titleLabel setText:title];
}

- (void)setPrice:(NSString *)price {
    if (!price || [price isEqualToString:@""] || [price isEqualToString:@"0"]) {
        [_priceLabel setText:@"面议"];
        [_priceUnitLabel setHidden:YES];
    }
    else {
        [_priceLabel setText:price];
        [_priceUnitLabel setHidden:NO];
    }
}

- (void)setType:(HPShareListCellType)type {
    switch (type) {
        case HPShareListCellTypeOwner:
            [_typeIcon setImage:ImageNamed(@"share_owner")];
            break;
            
        case HPShareListCellTypeStartup:
            [_typeIcon setImage:ImageNamed(@"share_startup")];
            break;
            
        default:
            break;
    }
}

- (void)setUnitType:(HPSharePriceUnitType)type {
    switch (type) {
        case HPSharePriceUnitTypeHour:
            [_priceUnitLabel setText:@"/小时"];
            break;
            
        case HPSharePriceUnitTypeDay:
            [_priceUnitLabel setText:@"/天"];
            break;
            
        default:
            break;
    }
}

- (void)setTags:(NSArray *)tags {
    for (int i = 0; i < _tagItems.count; i++) {
        HPTagView *tagItem = _tagItems[i];
        if (i < tags.count) {
            if ([tags[i] isEqualToString:@""]) {
                [tagItem setHidden:YES];
                continue;
            }
            [tagItem setHidden:NO];
            [tagItem setText:tags[i]];
        }
        else {
            [tagItem setHidden:YES];
        }
    }
}

- (void)setPhotoUrl:(NSString *)url {
    if (!url) {
        return;
    }
    
    [_photoView sd_setImageWithURL:[NSURL URLWithString:url]];
}


- (void)setReleaseTime:(NSString *)time {
    NSArray *strArray = [time componentsSeparatedByString:@" "];
    NSString *str;
    if (strArray.count > 0) {
        str = strArray[0];
        str = [NSString stringWithFormat:@"发布于 %@", str];
    }
    [_releaseTimeLabel setText:str];
}

@end
