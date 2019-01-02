//
//  HPDataHandlePickerView.h
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"
#import "HPLinkageData.h"
typedef void(^ViewTapClickCallback)(void);

typedef void(^FinishClickCallback)(NSString *model);
typedef void(^CancelClickCallback)(NSString *model);

NS_ASSUME_NONNULL_BEGIN

@interface HPDataHandlePickerView : HPBaseModalView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, copy) ViewTapClickCallback viewTapClickCallback;
@property (nonatomic, copy) FinishClickCallback finishClickCallback;
@property (nonatomic, copy) CancelClickCallback cancelClickCallback;

@property (nonatomic, strong) UIView *bgview;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic,strong) UIToolbar *toolBar;

/**
 用来说明显示什么功能的提示语句
 */
@property (nonatomic, copy) NSString *tipTitle;
@property (nonatomic, strong) HPLinkageData *dataSource;

@property (nonatomic, strong) NSMutableArray *areaNameArr;
@property (nonatomic, strong) UILabel* pickerLabel;
- (instancetype)initWithFrame:(CGRect)frame withModel:(HPLinkageData *)data;
@end

NS_ASSUME_NONNULL_END
