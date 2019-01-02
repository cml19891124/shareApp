//
//  HPDataHandlePickerView.m
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPDataHandlePickerView.h"
#import "HPAreaModel.h"
#define viewW   (self.frame.size.width)
#define viewH   (self.frame.size.height)

@implementation HPDataHandlePickerView

- (instancetype)initWithFrame:(CGRect)frame withModel:(HPLinkageData *)data
{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = data;
        _areaNameArr = [NSMutableArray array];
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapModalOutSide:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.bgview];
        [self addSubview:self.toolBar];
        [self addSubview:self.pickerView];
        [self.pickerView reloadAllComponents];
        [self setUpSubviewsLayout];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
//    for (int i = 0; i < self.dataSource.count; i++) {
//        HPReleaseDistrictModel *areaNameModel = _areaNameArr[i];
//        [_areaNameArr addObject:areaNameModel.name];
//    }
    
}

- (void)onTapModalOutSide:(UITapGestureRecognizer *)tap {
    if (self.viewTapClickCallback) {
        self.viewTapClickCallback();
    }
}

- (void)setUpSubviewsLayout
{
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight/3));
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.toolBar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.bgview);
    }];
    
    [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.bgview);
        make.height.mas_equalTo(getWidth(46.f));
    }];
}

#pragma mark - 背景视图
- (UIView *)bgview
{
    if (!_bgview) {
        UIView *bgview = [UIView new];
        bgview.backgroundColor = COLOR_GRAY_FFFFFF;
        bgview.layer.cornerRadius = 5.f;
        bgview.clipsToBounds = YES;
        _bgview = bgview;
        
    }
    return _bgview;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        //清除或改变分割线的颜色等。
        for(UIView *singleLine in _pickerView.subviews)
        {
            if (singleLine.frame.size.height < 1)
            {
                singleLine.backgroundColor = COLOR_GRAY_CCCCCC;
                [singleLine removeFromSuperview];
            }
        }
        [self.pickerView reloadAllComponents];
    }
    return _pickerView;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        
        UIBarButtonItem *finishBtn=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
        [finishBtn setTintColor:COLOR_RED_EA0000];
        UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
        [cancelBtn setTintColor:COLOR_GRAY_BBBBBB];

        UIBarButtonItem *flexible=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *leastTime=[[UIBarButtonItem alloc]initWithTitle:self.tipTitle style:UIBarButtonItemStyleDone target:self action:nil];
        [leastTime setEnabled:NO];
        
        NSArray *btnArr=[[NSArray alloc]initWithObjects:cancelBtn,flexible,leastTime,flexible,finishBtn, nil];
        [self.toolBar setItems:btnArr];
    }
    return _toolBar;
}

-(void)cancelAction{
    if (self.cancelClickCallback) {
        self.cancelClickCallback(@"");
    }
    [self removeFromSuperview];
}

-(void)finishAction{
    if (self.finishClickCallback) {
        self.finishClickCallback(self.pickerLabel.text);
    }
    [self removeFromSuperview];
}

#pragma mark - UIPickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    HPLinkageData *data = [HPLinkageData new];
    NSInteger rows = 0;
    switch (component) {
        case 0:
            rows = [data getParentCount];
            break;
        case 1:
            rows = [data getChildrenCountOfParentIndex:component];
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HPLinkageData *data = [HPLinkageData new];
    NSString * title = nil;
    switch (component) {
        case 0:
            
            title = @"fgsd";
            [self.pickerView reloadComponent:row];
            break;
        case 1:
            [data getChildModelOfParentIndex:row atChildIndex:component];
            title = @"city";
            break;
        default:
            break;
    }
    return title;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = kFont_Medium(15.f);
        pickerLabel.contentMode = UIViewContentModeCenter;
        pickerLabel.textColor = COLOR_BLACK_333333;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    _pickerLabel = pickerLabel;
    return pickerLabel;
}
/*
 如果我们使用这种方法来实现 UIPickerView 的展现的话，还有一个好处就是可以通过 调用 UIPickerView 的
- (nullable UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component;
方法就能轻松实现 其 iOS 7 以后就隐藏掉的属性  showsSelectionIndicator。
具体实现如下：
在实现了上面的复用自定义视图代理方法基础上，调用选择指定行列下标代理方法。
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UIView* view = [self pickerView:pickerView viewForRow:row forComponent:component reusingView:_pickerLabel];
//    view.backgroundColor = [UIColor greenColor];
}
@end
