//
//  HPTimePicker.m
//  HPShareApp
//
//  Created by Jay on 2018/12/10.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPTimePicker.h"
#import "HPImageUtil.h"

@interface HPTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UILabel *startTimeLabel;

@property (nonatomic, weak) UILabel *endTimeLabel;

@property (nonatomic, copy) NSString *startHour;

@property (nonatomic, copy) NSString *startMinute;

@property (nonatomic, copy) NSString *endHour;

@property (nonatomic, copy) NSString *endMinute;

@property (nonatomic,assign) NSInteger timeTag;

@property (nonatomic, weak) UIPickerView *pickerView;

@end


@implementation HPTimePicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupCustomView:(UIView *)view {
    _startHour = @"06";
    _startMinute = @"30";
    _endHour = @"23";
    _endMinute = @"59";
    
    UIView *centerView = [[UIView alloc] init];
    [view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).with.offset(getWidth(25.f));
        make.centerX.equalTo(view);
    }];
    
    UIControl *startTimeCtrl = [[UIControl alloc] init];
    [startTimeCtrl setTag:0];
    [startTimeCtrl addTarget:self action:@selector(onClickTimeCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:startTimeCtrl];
    [startTimeCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(centerView);
    }];
    
    UILabel *startTimeDescLabel = [[UILabel alloc] init];
    [startTimeDescLabel setFont:kFont_Medium(17.f)];
    [startTimeDescLabel setTextColor:COLOR_RED_FF3C5E];
    [startTimeDescLabel setText:@"开始时间"];
    [startTimeCtrl addSubview:startTimeDescLabel];
    [startTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(startTimeCtrl);
        make.height.mas_equalTo(startTimeDescLabel.font.pointSize);
    }];
    
    UILabel *startTimeLabel = [[UILabel alloc] init];
    [startTimeLabel setFont:kFont_Medium(17.f)];
    [startTimeLabel setTextColor:COLOR_RED_FF3C5E];
    [startTimeLabel setText:[NSString stringWithFormat:@"%@:%@", _startHour, _startMinute]];
    [startTimeCtrl addSubview:startTimeLabel];
    _startTimeLabel = startTimeLabel;
    [startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(startTimeDescLabel);
        make.top.equalTo(startTimeDescLabel.mas_bottom).with.offset(12.f);
        make.height.mas_equalTo(startTimeLabel.font.pointSize);
        make.bottom.equalTo(startTimeCtrl);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:COLOR_GRAY_EEEEEE];
    [centerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTimeCtrl.mas_right).with.offset(getWidth(11.f));
        make.centerY.equalTo(startTimeLabel);
        make.size.mas_equalTo(CGSizeMake(getWidth(30.f), 1.f));
    }];
    
    UIControl *endTimeCtrl = [[UIControl alloc] init];
    [endTimeCtrl setTag:1];
    [endTimeCtrl addTarget:self action:@selector(onClickTimeCtrl:) forControlEvents:UIControlEventTouchUpInside];
    [centerView addSubview:endTimeCtrl];
    [endTimeCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.mas_right).with.offset(getWidth(11.f));
        make.top.and.bottom.and.right.equalTo(centerView);
    }];
    
    UILabel *endTimeDescLabel = [[UILabel alloc] init];
    [endTimeDescLabel setFont:kFont_Medium(17.f)];
    [endTimeDescLabel setTextColor:COLOR_RED_FF3C5E];
    [endTimeDescLabel setText:@"结束时间"];
    [endTimeCtrl addSubview:endTimeDescLabel];
    [endTimeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(endTimeCtrl);
        make.height.mas_equalTo(endTimeDescLabel.font.pointSize);
    }];
    
    UILabel *endTimeLabel = [[UILabel alloc] init];
    [endTimeLabel setFont:kFont_Medium(17.f)];
    [endTimeLabel setTextColor:COLOR_RED_FF3C5E];
    [endTimeLabel setText:[NSString stringWithFormat:@"%@:%@", _endHour, _endMinute]];
    [endTimeCtrl addSubview:endTimeLabel];
    _endTimeLabel = endTimeLabel;
    [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endTimeDescLabel.mas_bottom).with.offset(12.f);
        make.centerX.equalTo(endTimeDescLabel);
        make.height.mas_equalTo(endTimeLabel.font.pointSize);
        make.bottom.equalTo(endTimeCtrl);
    }];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [pickerView.layer setCornerRadius:5.f];
    [pickerView.layer setBorderWidth:1.f];
    [pickerView.layer setBorderColor:COLOR_GRAY_F2F2F2.CGColor];
    [pickerView setBackgroundColor:COLOR_GRAY_F9FAFD];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [self addSubview:pickerView];
    _pickerView = pickerView;
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_bottom).with.offset(getWidth(25.f));
        make.centerX.equalTo(view);
        make.height.mas_equalTo(getWidth(175.f));
        make.width.mas_equalTo(getWidth(225.f));
    }];
    [pickerView selectRow:_startHour.integerValue inComponent:0 animated:NO];
    [pickerView selectRow:_startMinute.integerValue inComponent:1 animated:NO];
    
    [self setModalSize:CGSizeMake(getWidth(265.f), getWidth(334.f))];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIButton *hourbtn = (UIButton *)[self.pickerView viewForRow:self.startHour.integerValue forComponent:0];
    [hourbtn setSelected:YES];
    UIButton *minuteBtn = (UIButton *)[self.pickerView viewForRow:self.startMinute.integerValue forComponent:1];
    [minuteBtn setSelected:YES];
}

- (void)onClickTimeCtrl:(UIControl *)ctrl {
    _timeTag = ctrl.tag;
    
    if (_timeTag == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.pickerView selectRow:self.startHour.integerValue inComponent:0 animated:NO];
        } completion:^(BOOL finished) {
            UIButton *hourbtn = (UIButton *)[self.pickerView viewForRow:self.startHour.integerValue forComponent:0];
            [hourbtn setSelected:YES];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.pickerView selectRow:self.startMinute.integerValue inComponent:1 animated:NO];
        } completion:^(BOOL finished) {
            UIButton *minuteBtn = (UIButton *)[self.pickerView viewForRow:self.startMinute.integerValue forComponent:1];
            [minuteBtn setSelected:YES];
        }];
    }
    else if (_timeTag == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.pickerView selectRow:self.endHour.integerValue inComponent:0 animated:NO];
        } completion:^(BOOL finished) {
            UIButton *hourbtn = (UIButton *)[self.pickerView viewForRow:self.endHour.integerValue forComponent:0];
            [hourbtn setSelected:YES];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.pickerView selectRow:self.endMinute.integerValue inComponent:1 animated:NO];
        } completion:^(BOOL finished) {
            UIButton *minuteBtn = (UIButton *)[self.pickerView viewForRow:self.endMinute.integerValue forComponent:1];
            [minuteBtn setSelected:YES];
        }];
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (view == nil) {
        UIButton *btn = [[UIButton alloc] init];
        [btn.titleLabel setFont:kFont_Medium(19.f)];
        [btn setTitleColor:COLOR_GRAY_999999 forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
        UIImage *normalImage = [HPImageUtil getImageByColor:UIColor.clearColor inRect:CGRectMake(0.f, 0.f, getWidth(112.f), getWidth(35.f))];
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        UIImage *selectedImage = [HPImageUtil getImageByColor:COLOR_RED_FF3C5E inRect:CGRectMake(0.f, 0.f, getWidth(112.f), getWidth(35.f))];
        [btn setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [btn setTitle:[NSString stringWithFormat:@"%02ld",(long)row] forState:UIControlStateNormal];
        view = btn;
    }
    
    return view;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return getWidth(112.f);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return getWidth(35.f);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UIButton *btn = (UIButton *)[pickerView viewForRow:row forComponent:component];
    [btn setSelected:YES];
    
    if (_timeTag == 0) {
        if (component == 0) {
            _startHour = btn.titleLabel.text;
        }
        else if (component == 1) {
            _startMinute = btn.titleLabel.text;
        }
        
        [_startTimeLabel setText:[NSString stringWithFormat:@"%@:%@", _startHour, _startMinute]];
    }
    else if (_timeTag == 1) {
        if (component == 0) {
            _endHour = btn.titleLabel.text;
        }
        else if (component == 1) {
            _endMinute = btn.titleLabel.text;
        }
        
        [_endTimeLabel setText:[NSString stringWithFormat:@"%@:%@", _endHour, _endMinute]];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    }
    else if (component == 1) {
        return 60;
    }
    
    return 0;
}

- (NSString *)getTimeStr {
    return [NSString stringWithFormat:@"%@:%@,%@:%@", _startHour, _startMinute, _endHour, _endMinute];
}

@end
