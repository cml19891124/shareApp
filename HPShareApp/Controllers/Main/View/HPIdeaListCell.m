//
//  HPIdeaListCell.m
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaListCell.h"
#import "HPTimeString.h"

@implementation HPIdeaListCell

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
    [self.contentView addSubview:self.ideaImageview];
    
    [self.contentView addSubview:self.ideaTitle];
    
    [self.contentView addSubview:self.readBtn];
    
    [self.contentView addSubview:self.ideaSubtitle];
    
}

- (UIImageView *)ideaImageview
{
    if (!_ideaImageview) {
        _ideaImageview = [UIImageView new];
        _ideaImageview.image = ImageNamed(@"");
    }
    return _ideaImageview;
}

- (UILabel *)ideaTitle
{
    if (!_ideaTitle) {
        _ideaTitle = [UILabel new];
        _ideaTitle.textColor = COLOR_BLACK_333333;
        _ideaTitle.font = kFont_Medium(16.f);
        _ideaTitle.textAlignment = NSTextAlignmentLeft;
        //高度自适应，前提不设置宽度，高度自适应
        [_ideaTitle setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _ideaTitle.numberOfLines = 0;
        //宽度自适应
        _ideaTitle.adjustsFontSizeToFitWidth = YES;
    }
    return _ideaTitle;
}

- (UILabel *)ideaSubtitle
{
    if (!_ideaSubtitle) {
        _ideaSubtitle = [UILabel new];
        _ideaSubtitle.textColor = COLOR_GRAY_999999;
        _ideaSubtitle.font = kFont_Regular(12.f);
        _ideaSubtitle.textAlignment = NSTextAlignmentLeft;

    }
    return _ideaSubtitle;
}

- (UIButton *)readBtn
{
    if (!_readBtn) {
        _readBtn = [UIButton new];
        [_readBtn setTitle:@"今日推荐" forState:UIControlStateNormal];
        [_readBtn setTitleColor:COLOR_GRAY_F42000 forState:UIControlStateNormal];
        _readBtn.backgroundColor = COLOR_RED_FFE6E2;
        _readBtn.layer.cornerRadius = 2.f;
        _readBtn.layer.masksToBounds = YES;
        _readBtn.titleLabel.font = kFont_Regular(9.f);
        [_readBtn addTarget:self action:@selector(todayIntroduce:) forControlEvents:UIControlEventTouchUpInside];
        _readBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _readBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _readBtn;
}

- (void)setUpIdearListSubviewsMasonry
{
    
    [self.ideaImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(getWidth(-16.f));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(getWidth(109.f),(getWidth(84.f))));
    }];
    
    [self.ideaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getWidth(20.f));
        make.top.mas_equalTo(getWidth(21.f));
        make.right.mas_equalTo(self.ideaImageview.mas_left).offset(getWidth(-5.f));
    }];
    
    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ideaImageview.mas_left).offset(getWidth(-23.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(50.f), getWidth(12.f)));
        make.bottom.mas_equalTo(getWidth(-20.f));
    }];
    
    [self.ideaSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ideaTitle);
        make.right.mas_equalTo(self.readBtn.mas_left).offset(getWidth(-5.f));
        make.bottom.mas_equalTo(getWidth(-21.f));
        make.height.mas_equalTo(self.ideaSubtitle.font.pointSize);
    }];
}

- (void)setModel:(HPIdeaListModel *)model
{
    _model = model;
    NSArray *pics = model.pictures;
    if (pics.count && pics) {
        HPIdeaPicturesModel *picturesUrl = pics[0];
        [self.ideaImageview sd_setImageWithURL:[NSURL URLWithString:picturesUrl.pictureUrl] placeholderImage:ImageNamed(@"example_space")];
    }
    
    self.ideaTitle.numberOfLines = 0;
    self.ideaTitle.lineBreakMode = NSLineBreakByWordWrapping;
    self.ideaTitle.text = model.title;
    
    NSDate *currentDataTime = (NSDate *)[HPTimeString string2DateWithString:model.createTime pattern:@""];
    NSString *getFo = [HPTimeString getPassTimeSometimeWithHorFormatter:currentDataTime];
    NSArray *yesterdayBeforArr = [getFo componentsSeparatedByString:@" "];
    NSString *yesterdayStr = yesterdayBeforArr.firstObject;
    if ([getFo containsString:@"今天"]) {
        self.readBtn.hidden = NO;
        self.ideaSubtitle.text = [NSString stringWithFormat:@"%@ . %@次阅读",[getFo substringFromIndex:2],model.readingQuantity];

    }else if ([getFo containsString:@"昨天"]) {
        self.readBtn.hidden = NO;
        self.ideaSubtitle.text = [NSString stringWithFormat:@"%@ . %@次阅读",[getFo substringFromIndex:2],model.readingQuantity];
        
    }else{
        
        self.readBtn.hidden = YES;
        self.ideaSubtitle.text = [NSString stringWithFormat:@"%@ . %@次阅读",yesterdayStr,model.readingQuantity];

    }
}

- (void)todayIntroduce:(UIButton *)button
{
    if (self.todayIntroduceBlcok) {
        self.todayIntroduceBlcok(button.currentTitle);
    }
}
@end
