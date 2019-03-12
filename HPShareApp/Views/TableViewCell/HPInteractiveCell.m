//
//  HPInteractiveCellTableViewCell.m
//  HPShareApp
//
//  Created by HP on 2018/12/6.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPInteractiveCell.h"
#import "HPTimeString.h"
#import "HPImageUtil.h"

@implementation HPInteractiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:COLOR_GRAY_FFFFFF];
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50.f * g_rateWidth, 50.f * g_rateWidth));
            make.centerY.equalTo(self);
            make.left.mas_equalTo(self).offset(15.f * g_rateWidth);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:16.f]];
        [titleLabel setTextColor:COLOR_BLACK_444444];
//        [titleLabel setHighlightedTextColor:COLOR_RED_FC4865];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).with.offset(18.f * g_rateWidth);
            make.top.equalTo(self).offset(19.f * g_rateWidth);
            make.height.mas_equalTo(15.5f);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        
        UILabel *subtitleLabel = [[UILabel alloc] init];
        [subtitleLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:12.f]];
        [subtitleLabel setTextColor:COLOR_GRAY_BBBBBB];
        [subtitleLabel setHighlightedTextColor:COLOR_GRAY_BBBBBB];
        [subtitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).with.offset(18.f * g_rateWidth);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f * g_rateWidth);
            make.height.mas_equalTo(12.f);
            make.width.mas_equalTo(kScreenWidth/2);

        }];
        
        NSString *historyTime = [HPTimeString getCurrentTimes];
        CGFloat timeW = BoundWithSize(historyTime,kScreenWidth, 11).size.width;
        UILabel *timeLabel = [[UILabel alloc] init];
        [timeLabel setFont:[UIFont fontWithName:FONT_REGULAR size:11.f]];
        [timeLabel setTextColor:COLOR_GRAY_999999];
        [timeLabel setHighlightedTextColor:COLOR_GRAY_999999];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.text = historyTime;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-15.f * g_rateWidth);
            make.top.equalTo(self).offset(24.f);
            make.height.mas_equalTo(9.f);
            make.width.mas_equalTo(timeW+ 15);
        }];
        
        UIButton *badgeValue = [UIButton buttonWithType:UIButtonTypeCustom];
//        [badgeValue setBackgroundImage:[HPImageUtil getImageByColor:COLOR_RED_FF3C5E inRect:CGRectMake(56.f * g_rateWidth, 18.f * g_rateHeight, 10.f * g_rateWidth, 10.f * g_rateWidth)] forState:UIControlStateNormal];
//        [badgeValue setTitle:@"2" forState:UIControlStateNormal];
//        badgeValue.titleLabel.font = [UIFont fontWithName:FONT_REGULAR size:5];
//        [badgeValue setTitleColor:COLOR_GREEN_EFF3F6 forState:UIControlStateNormal];
        badgeValue.backgroundColor = COLOR_RED_FF3C5E;
        badgeValue.layer.cornerRadius = 5.f *g_rateWidth;
        badgeValue.hidden = YES;
        [self.contentView addSubview:badgeValue];
        _badgeValue = badgeValue;
        [badgeValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(56.f * g_rateWidth);
            make.top.mas_equalTo(self).offset(18.f * g_rateWidth);
            make.size.mas_equalTo(CGSizeMake(10.f *g_rateWidth, 10.f *g_rateWidth));
        }];
        self.badgeValue = badgeValue;
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.timeLabel.mas_left).offset(10);
        }];
        
        [self.subtitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.timeLabel.mas_left).offset(10);
        }];
    }
    return self;
}

- (void)setModel:(HPInterActiveModel *)model
{
    _model = model;
    self.iconView.image = ImageNamed(model.photo);
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    if ([model.title isEqualToString:@"活动中心"]||[model.subtitle isEqualToString:@"暂无数据"]||!model.hasnoti) {
        self.badgeValue.hidden = YES;
    }else{
        self.badgeValue.hidden = NO;

    }
}
@end
