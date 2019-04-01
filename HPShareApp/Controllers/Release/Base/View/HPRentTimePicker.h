//
//  HPRentTimePicker.h
//  HPShareApp
//
//  Created by HP on 2019/3/21.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HPBaseDialogView.h"

typedef void(^RentTimeBlock)(NSString *startTime,NSString *endTime);
NS_ASSUME_NONNULL_BEGIN

@interface HPRentTimePicker : HPBaseDialogView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *startTimeArr;

@property (nonatomic, strong) NSArray *endTimeArr;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, copy) RentTimeBlock timeBlock;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *endTime;

@end

NS_ASSUME_NONNULL_END
