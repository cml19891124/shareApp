//
//  HPRentDuringView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/1.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^RentDuringBlock)(NSString *startTime,NSString *endTime);


NS_ASSUME_NONNULL_BEGIN

@interface HPRentDuringView : HPBaseModalView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) NSArray *startTimeArr;

@property (nonatomic, strong) NSArray *endTimeArr;

@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, copy) RentDuringBlock timeBlock;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, strong) UIView *rentView;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *lineView;

@property (strong, nonatomic) UILabel *arriveLabel;

@property (strong, nonatomic) UILabel *leaveLabel;

@end

NS_ASSUME_NONNULL_END
