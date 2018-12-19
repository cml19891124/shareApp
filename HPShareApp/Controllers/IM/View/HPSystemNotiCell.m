//
//  HPSystemNotiCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/12.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPSystemNotiCell.h"
#import "HPTimeString.h"

@implementation HPSystemNotiCell

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
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews
{
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = COLOR_GRAY_999999;
    timeLabel.font = kFont_Regular(11);
    timeLabel.text = @"我在这儿";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(getWidth(11.f));
        make.top.mas_equalTo(getWidth(14.f));
        make.centerX.mas_equalTo(self.contentView);
    }];
    self.timeLabel = timeLabel;
    UIView *shawView = [[UIView alloc] init];
    [self.contentView addSubview:shawView];
    [shawView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(140.f)));
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(getWidth(15.f));
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self setupShadowOfNotiView:shawView];
}
- (void)setupShadowOfNotiView:(UIView *)view
{
    view.backgroundColor = UIColor.whiteColor;
    [view.layer setShadowColor:COLOR_GRAY_A5B9CE.CGColor];
    [view.layer setShadowOffset:CGSizeMake(0.f, 4.f)];
    [view.layer setShadowRadius:15.f];
    [view.layer setShadowOpacity:0.3f];
    [view.layer setCornerRadius:15.f];
    
    UIButton *notiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notiBtn.layer.cornerRadius = 3.5f;
    notiBtn.layer.masksToBounds = YES;
    notiBtn.backgroundColor = COLOR_RED_FF3C5E;
    [view addSubview:notiBtn];
    _notiBtn = notiBtn;
    [notiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(getWidth(7.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(7.f), getWidth(7.f)));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = COLOR_BLACK_333333;
    titleLabel.font = kFont_Medium(15);
    titleLabel.text = @"我在这儿";
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(getWidth(14.f));
        make.left.mas_equalTo(view).offset(getWidth(16.f));
    }];
    self.titleLabel = titleLabel;
    /*
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = UIColor.clearColor;
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_BLUE_2AA5FC forState:UIControlStateNormal];
    moreBtn.titleLabel.font = kFont_Regular(12);
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [moreBtn addTarget:self action:@selector(checkMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:moreBtn];
    _moreBtn = moreBtn;
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-16.f));
        make.top.mas_equalTo(view).offset(getWidth(16.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(50.f), getWidth(12.f)));
    }];*/
    
    UIView *notiLine = [[UIView alloc] init];
    notiLine.backgroundColor = COLOR_GRAY_F2F2F2;
    [view addSubview:notiLine];
    self.notiLine = notiLine;
    [notiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(1.f));
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(getWidth(12.f));
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = COLOR_GRAY_AAAAAA;
    contentLabel.font = kFont_Medium(12);
    contentLabel.text = @"我在这儿";
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-18.f));
        make.height.mas_equalTo(getWidth(48.f));
        make.top.mas_equalTo(notiLine.mas_bottom).offset(getWidth(17.f));
        make.left.mas_equalTo(view).offset(getWidth(16.f));
    }];
    self.contentLabel = contentLabel;
}


- (void)setModel:(HPInterActiveModel *)model
{
    _model = model;
    _timeLabel.text = [HPTimeString getPassTimeSometimeWith:[HPTimeString getDateWithString:model.date]] ;
    _titleLabel.text = model.title;
    _contentLabel.text = model.subtitle;
}

- (void)checkMoreInfo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickToCheckMoreNoti:)]) {
        [self.delegate clickToCheckMoreNoti:_model];
    }
}
@end
