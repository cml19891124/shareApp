//
//  HPPartyCenterCell.m
//  HPShareApp
//
//  Created by caominglei on 2018/12/13.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPPartyCenterCell.h"
#import "HPTimeString.h"

@implementation HPPartyCenterCell

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
        make.size.mas_equalTo(CGSizeMake(getWidth(345.f), getWidth(295.f)));
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
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(getWidth(16.f));
        make.top.mas_equalTo(getWidth(14.f));
        make.left.mas_equalTo(view).offset(getWidth(17.f));
    }];
    self.titleLabel = titleLabel;
    
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.layer.cornerRadius = 3.5f;
    imageBtn.layer.masksToBounds = YES;
    imageBtn.backgroundColor = COLOR_RED_FF3C5E;
    imageBtn.userInteractionEnabled = NO;
    [imageBtn setImage:ImageNamed(@"party") forState:UIControlStateNormal];
    [view addSubview:imageBtn];
    _imageBtn = imageBtn;
    [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(15.f));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(getWidth(12.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(315.f), getWidth(160.f)));
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = COLOR_GRAY_AAAAAA;
    contentLabel.font = kFont_Medium(11);
    contentLabel.text = @"我在这儿";
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-22.f));
        make.height.mas_equalTo(getWidth(29.f));
        make.top.mas_equalTo(imageBtn.mas_bottom).offset(getWidth(14.f));
        make.left.mas_equalTo(view).offset(getWidth(15.f));
    }];
    self.contentLabel = contentLabel;
    
    UIView *notiLine = [[UIView alloc] init];
    notiLine.backgroundColor = COLOR_GRAY_F2F2F2;
    [view addSubview:notiLine];
    self.notiLine = notiLine;
    [notiLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(1.f));
        make.left.right.mas_equalTo(view);
        make.top.mas_equalTo(contentLabel.mas_bottom).offset(getWidth(18.f));
    }];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.backgroundColor = UIColor.clearColor;
    [moreBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_BLACK_666666 forState:UIControlStateNormal];
    moreBtn.titleLabel.font = kFont_Medium(12);
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [moreBtn addTarget:self action:@selector(checkMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:moreBtn];
    _moreBtn = moreBtn;
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(getWidth(16.f));
        make.top.mas_equalTo(notiLine.mas_bottom).offset(getWidth(9.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(100.f), getWidth(12.f)));
    }];
    
    UIButton *rowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rowBtn.backgroundColor = UIColor.clearColor;
    [rowBtn addTarget:self action:@selector(checkMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rowBtn];
    [rowBtn setImage:ImageNamed(@"shouye_gengduo") forState:UIControlStateNormal];
    [rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view).offset(getWidth(-16.f));
        make.centerY.mas_equalTo(moreBtn);
        make.size.mas_equalTo(CGSizeMake(getWidth(6.f), getWidth(11.f)));
    }];
}

- (NSDate *)getLocateTime:(unsigned int)timeStamp {
    
    double dTimeStamp = (double)timeStamp;
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:dTimeStamp];
    
    return confromTimesp;
    
}

- (void)checkMoreInfo:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(clickTocheckMoreInfo:)]) {
        [self.delegate clickTocheckMoreInfo:_model];
    }
}

- (void)setModel:(HPPartyCenterModel *)model
{
    _model = model;
    NSDate *tme = [self getLocateTime:[model.createTime intValue]];
    _timeLabel.text = [HPTimeString getPassTimeSometimeWith:tme];
    _titleLabel.text = model.title;
    _contentLabel.text = model.message;
    
}

@end
