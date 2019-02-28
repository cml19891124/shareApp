//
//  HPHotShareStoreCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHotShareStoreCell.h"

@implementation HPHotShareStoreCell

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
        NSArray *hotShareImageArr = @[ImageNamed(@"home_page_hot_shop_baoan"),ImageNamed(@"home_page_hot_shop_longhua"),ImageNamed(@"home_page_hot_shop_nanshan")];
        _areaArray = @[@"宝安区",@"龙华区",@"南山区"];

        self.hotShareImageArr = [NSMutableArray array];
        [self.hotShareImageArr addObjectsFromArray:hotShareImageArr];
        [self setUpHotShareSubviews];
        [self setUpHotShareCellSubviewsFrame];
        
    }
    return self;
}

- (void)setUpHotShareSubviews
{
    [self.contentView addSubview:self.titleLabel];
    HPRightImageButton *moreBtn = [self setupGotoBtnWithTitle:@"更多"];
    moreBtn.font = iPhone5?kFont_Medium(12.f):kFont_Medium(14.f);
    [self.contentView addSubview:moreBtn];
    self.moreBtn = moreBtn;
    
    for (int i = 0; i < self.hotShareImageArr.count; i++) {
        HPHotImageView *areaImageView = [[HPHotImageView alloc] initWithFrame:CGRectZero andAreaString:_areaArray[i]];
        areaImageView.image = self.hotShareImageArr[i];
        [self.contentView addSubview:areaImageView];
        areaImageView.userInteractionEnabled = YES;
        areaImageView.title = self.areaArray[i];
        _areaImageView = areaImageView;
        areaImageView.tag = 100 + i;
        CGFloat areaW = (kScreenWidth - getWidth(360.f))/2;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hotImageViewTap:)];
        [areaImageView addGestureRecognizer:tap];
        [self.areaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(getWidth(15.f) + (areaW + getWidth(110.f)) * i);
            make.size.mas_equalTo(CGSizeMake(getWidth(110.f), getWidth(70.f)));
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
    }
    
    
}

- (void)hotImageViewTap:(UITapGestureRecognizer *)tap
{
    if (self.tapHotImageViewBlock) {
        self.tapHotImageViewBlock(tap.view.tag);
    }
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = COLOR_BLACK_333333;
        _titleLabel.font = kFont_Medium(20.f);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"热门拼租店铺";
    }
    return _titleLabel;
}

- (HPRightImageButton *)setupGotoBtnWithTitle:(NSString *)title {
    HPRightImageButton *btn = [[HPRightImageButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"shouye_gengduo"]];
    [btn setFont:[UIFont fontWithName:FONT_MEDIUM size:15.f]];
    [btn setText:title];
    [btn setSpace:9.f];
    [btn setColor:COLOR_BLACK_666666];
    [btn setSelectedColor:COLOR_BLACK_333333];
    [btn addTarget:self action:@selector(onClickGotoCtrl:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)onClickGotoCtrl:(UIButton *)button
{
    if (self.clickMoreBtnBlock) {
        self.clickMoreBtnBlock();
    }
}

- (void)setUpHotShareCellSubviewsFrame
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.right.mas_equalTo(getWidth(-15.f));
        make.height.mas_equalTo(getWidth(48.f));
        make.top.mas_equalTo(getWidth(15.f));
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(getWidth(-16.f));
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.mas_equalTo(getWidth(46.f));
    }];
}

@end
