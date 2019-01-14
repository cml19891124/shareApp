//
//  HPHeaderCell.m
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHeaderCell.h"

@implementation HPHeaderCell

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
        [self setUpIdearListSubviews];
        
        [self setUpIdearListSubviewsMasonry];

    }
    return self;
}

- (void)setUpIdearListSubviews
{
    
    [self.contentView addSubview:self.bgView];
    
    [self.contentView addSubview:self.whatIsShareSpace];
    
    [self.contentView addSubview:self.headTitlelabel];

    [self.contentView addSubview:self.headImageview];

}

- (void)setUpIdearListSubviewsMasonry
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.bottom.mas_equalTo(getWidth(-116.f));
    }];
    
    [self.whatIsShareSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(getWidth(57.f));
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(345.f * g_rateWidth, 150.f * g_rateWidth));
    }];
    
    [self setupWhatIsShareSpace:self.whatIsShareSpace];
    
    [self.headTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(self.whatIsShareSpace.mas_bottom).offset(getWidth(20.f));
        make.width.mas_equalTo(getWidth(36.f));
        make.height.mas_equalTo(self.headTitlelabel.font.pointSize);
    }];
    
    [self.headImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headTitlelabel.mas_right).offset(getWidth(4.f));
        make.top.mas_equalTo(self.headTitlelabel);
        make.size.mas_equalTo(CGSizeMake(getWidth(32.f), getWidth(19.f)));
    }];
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [UIImageView new];
        _bgView.userInteractionEnabled = YES;
        [_bgView setImage:[UIImage imageNamed:@"sharing_method_background"]];
    }
    return _bgView;
}

- (UIControl *)whatIsShareSpace
{
    if (!_whatIsShareSpace) {
        _whatIsShareSpace = [UIControl new];
        [_whatIsShareSpace.layer setCornerRadius:6.5f];
        [_whatIsShareSpace.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
        [_whatIsShareSpace.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
        [_whatIsShareSpace.layer setShadowRadius:11.f];
        [_whatIsShareSpace.layer setShadowOpacity:1.f];
        [_whatIsShareSpace setBackgroundColor:UIColor.whiteColor];
        [_whatIsShareSpace setTag:0];
        [_whatIsShareSpace addTarget:self action:@selector(onClickShareSpaceCtrl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whatIsShareSpace;
}

- (UILabel *)headTitlelabel
{
    if (!_headTitlelabel) {
        _headTitlelabel = [UILabel new];
        _headTitlelabel.text = @"合店";
        _headTitlelabel.textColor = COLOR_BLACK_333333;
        _headTitlelabel.textAlignment = NSTextAlignmentLeft;
        _headTitlelabel.font = kFont_Bold(18.f);
    }
    return _headTitlelabel;
}

- (UIImageView *)headImageview
{
    if (!_headImageview) {
        _headImageview = [UIImageView new];
        _headImageview.image = ImageNamed(@"sharing_method_headlines");
    }
    return _headImageview;
}


- (void)setupWhatIsShareSpace:(UIView *)view {
    UILabel *titleLabel = [self setupTitle:@"什么是共享空间?" ofView:view];
    UIImageView *iconView = [self setupIcon:[UIImage imageNamed:@"idea_what_is_share_space"] ofView:view];
    
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"共享经济已死？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20.f * g_rateWidth);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"NO !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f * g_rateWidth);
        make.centerY.equalTo(questionLabel);
        make.height.mas_equalTo(answerLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [descLabel setText:@"共享空间告诉你什么才是共享的正确打开方式！"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(iconView.mas_left).with.offset(11.f * g_rateWidth);
        make.top.equalTo(questionLabel.mas_bottom).with.offset(15.f * g_rateWidth);
    }];
}

#pragma mark - setupCommonUI

- (UILabel *)setupTitle:(NSString *)title ofView:(UIView *)view {
    UIView *line = [[UIView alloc] init];
    [line.layer setCornerRadius:1.f];
    [line setBackgroundColor:COLOR_RED_FF4562];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(18.f * g_rateWidth);
        make.top.equalTo(view).with.offset(21.f * g_rateWidth);
        make.size.mas_equalTo(CGSizeMake(3.f, 16.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:COLOR_BLACK_333333];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).with.offset(9.f);
        make.centerY.equalTo(line);
        make.height.mas_equalTo(titleLabel.font.pointSize);
    }];
    
    return titleLabel;
}


- (UIImageView *)setupIcon:(UIImage *)icon ofView:(UIView *)view {
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:icon];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).with.offset(-15.f * g_rateWidth);
        make.centerY.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(110.f * g_rateWidth, 110.f * g_rateWidth));
    }];
    
    return iconView;
}


#pragma mark -  点击事件
- (void)onClickShareSpaceCtrl:(UIControl *)ctrol
{
    if (self.headerClickBlock) {
        self.headerClickBlock(ctrol.tag);
    }
}
@end
