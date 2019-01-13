//
//  HPIdeaListCell.m
//  HPShareApp
//
//  Created by HP on 2019/1/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPIdeaListCell.h"

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
        _ideaImageview.backgroundColor = COLOR_RED_EA0000;
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
        make.height.mas_equalTo(self.ideaTitle.font.pointSize);
    }];
    
    [self.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ideaImageview.mas_left).offset(getWidth(-23.f));
        make.size.mas_equalTo(CGSizeMake(getWidth(50.f), getWidth(12.f)));
        make.bottom.mas_equalTo(getWidth(-20.f));
    }];
    
    [self.ideaSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ideaTitle);
        make.right.mas_equalTo(self.readBtn.mas_left).offset(getWidth(-46.f));
        make.bottom.mas_equalTo(getWidth(-21.f));
        make.height.mas_equalTo(self.ideaSubtitle.font.pointSize);
    }];
}

- (void)setModel:(HPIdeaListModel *)model
{
    _model = model;
    [self.ideaImageview sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:ImageNamed(@"")];
    self.ideaTitle.text = model.title;
    self.ideaSubtitle.text = [NSString stringWithFormat:@"2小时前.%@次阅读",model.readingQuantity];
}

- (void)todayIntroduce:(UIButton *)button
{
    if (self.todayIntroduceBlcok) {
        self.todayIntroduceBlcok(button.currentTitle);
    }
}
@end
