//
//  HPCalenderView.h
//  HPShareApp
//
//  Created by HP on 2019/3/29.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

#import "YZXSelectDateViewController.h"

typedef void(^CalenderViewBlock)(NSString *startDate, NSString *endDate, YZXTimeToChooseType selectedType);

typedef void(^SelectSingleDay)(NSString *day);

typedef void(^SelectDaysblcok)(YZXTimeToChooseType selectedType);

NS_ASSUME_NONNULL_BEGIN

@interface HPCalenderView : HPBaseModalView<SelectedDayDelegate>

@property (nonatomic, strong) UIView *view;

@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) UIButton *singleSelectBtn;

@property (nonatomic, strong) UIView *marginView;

@property (nonatomic, strong) UIButton *duringBtn;

@property (nonatomic, strong) YZXSelectDateViewController *selectDaysVC;

@property (nonatomic, copy) CalenderViewBlock calenderBlock;

@property (nonatomic, assign) YZXTimeToChooseType         selectedType;
@property (nonatomic, copy) NSString             *startDate;
@property (nonatomic, copy) NSString             *endDate;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, copy) SelectSingleDay singleBlock;

@property (nonatomic, copy) SelectDaysblcok selectBlock;
@end

NS_ASSUME_NONNULL_END
