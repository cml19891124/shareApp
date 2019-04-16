//
//  YZXCalendarCollectionViewCell.m
//  YZXCalendar
//
//  Created by 尹星 on 2017/6/28.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import "YZXCalendarCollectionViewCell.h"
#import "YZXCalendarModel.h"

#import "YZXCalendarHeader.h"

#import "UIColor+Hexadecimal.h"

#import "YZXCalendarHelper.h"

#import "Masonry.h"

#import "HPGlobalVariable.h"

#import "Macro.h"

#import "HPGradientUtil.h"

@interface YZXCalendarCollectionViewCell ()


@end

@implementation YZXCalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.priceLabel.hidden = NO;
    self.day.font = kFont_Bold(14.f);
    self.priceLabel.font = kFont_Regular(11.f);
    self.day.textColor = COLOR_GRAY_E4E4E4;
    //保存原来的价格
    self.originalPrice = self.priceLabel.text;
    self.originalColor = self.priceLabel.textColor;
    self.originalFont = self.priceLabel.font;
    
    
    self.day.layer.cornerRadius = 2;
    self.day.layer.masksToBounds = YES;

}

- (void)setIsHidden:(BOOL)isHidden
{
    if (isHidden) {
        self.priceLabel.hidden = YES;
        [self.day mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.width.mas_equalTo(getWidth(30.f));
            make.height.mas_equalTo(getWidth(24.f));
        }];
    }else{
        [self.day mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.width.mas_equalTo(getWidth(30.f));
            make.height.mas_equalTo(getWidth(24.f));
            make.top.mas_equalTo(self.priceLabel.mas_bottom).offset(getWidth(2.f));
        }];
    }
}

- (void)layoutContentViewOfCollectionViewCellWithCellIndxePath:(NSIndexPath *)indexPath model:(YZXCalendarModel *)model
{
    self.backgroundColor = [UIColor whiteColor];
    NSInteger firstDayInMonth = model.firstDayOfTheMonth;
    //从每月的第一天开始设置cell.day的值
    if (indexPath.item >= firstDayInMonth - 1 && indexPath.item <= firstDayInMonth + model.numberOfDaysOfTheMonth - 2) {
        self.day.text = [NSString stringWithFormat:@"%ld",indexPath.item - (firstDayInMonth - 2)];
        self.userInteractionEnabled = YES;

    }else {
        self.day.text = @"";
        self.userInteractionEnabled = NO;
    }
    //周末字体为红色
    if (indexPath.item % 7 == 0 || indexPath.item % 7 == 6) {
        self.day.textColor = CustomRedColor;
    }else {
        self.day.textColor = CustomBlackColor;
    }
    //今天
    if ([YZXCalendarHelper.helper determineWhetherForTodayWithIndexPaht:indexPath model:model] == YZXDateEqualToToday) {
        self.day.text = @"今天";
        self.day.textColor = CustomRedColor;
    }else if ([YZXCalendarHelper.helper determineWhetherForTodayWithIndexPaht:indexPath model:model] == YZXDateLaterThanToday) {//判断日期是否超过今天
        self.day.textColor = COLOR_GRAY_999999;
        self.userInteractionEnabled = YES;
    }else{
        self.day.textColor = COLOR_GRAY_E4E4E4;
    }
    

}

- (void)changeContentViewBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
}

- (void)changeDayBackgroundColor:(UIColor *)backgroundColor
{
    self.day.backgroundColor = backgroundColor;
}

- (void)changeDayTextColor:(UIColor *)textColor
{
    self.day.textColor = textColor;
}

- (NSString *)getTheCellDayText
{
    return self.day.text;
}

@end
