//
//  YZXCalendarCollectionViewCell.h
//  YZXCalendar
//
//  Created by 尹星 on 2017/6/28.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZXCalendarModel;

@interface YZXCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) UIButton *lineBtn;

@property (nonatomic, copy) NSString *originalPrice;

@property (nonatomic, strong) UIColor *originalColor;

@property (nonatomic, strong) UIFont *originalFont;

@property (weak, nonatomic) IBOutlet UILabel *day;

@property (nonatomic, assign) BOOL isHidden;

@property (assign, nonatomic) BOOL userActivity;

- (void)layoutContentViewOfCollectionViewCellWithCellIndxePath:(NSIndexPath *)indexPath model:(YZXCalendarModel *)model;

- (void)changeContentViewBackgroundColor:(UIColor *)backgroundColor;

- (void)changeDayTextColor:(UIColor *)textColor;

- (void)changeDayBackgroundColor:(UIColor *)backgroundColor;

- (NSString *)getTheCellDayText;

@end
