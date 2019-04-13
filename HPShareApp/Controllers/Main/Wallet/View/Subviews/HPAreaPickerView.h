//
//  HPAreaPickerView.h
//  HPShareApp
//
//  Created by caominglei on 2019/4/12.
//  Copyright © 2019 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseModalView.h"

typedef void(^AreaBlock)(NSString * _Nullable province,NSString * _Nullable city);

NS_ASSUME_NONNULL_BEGIN

@interface HPAreaPickerView : HPBaseModalView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *areaArray;

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIButton *cancelBtn;

@property (strong, nonatomic) UIButton *confirmBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, copy) AreaBlock areaBlock;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, strong) NSMutableArray *provinceArray;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (strong, nonatomic) NSMutableArray *allArray;

@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) NSMutableDictionary *valuesDict;

@end

NS_ASSUME_NONNULL_END
