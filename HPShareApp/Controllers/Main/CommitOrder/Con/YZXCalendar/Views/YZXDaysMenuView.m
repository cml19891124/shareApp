//
//  YZXDaysMenuView.m
//  YZXCalendar
//
//  Created by 尹星 on 2017/6/27.
//  Copyright © 2017年 尹星. All rights reserved.
//
#import "HPSingleton.h"
#import "HPTimeString.h"

#import "YZXDaysMenuView.h"
#import "YZXCalendarCollectionViewCell.h"
#import "YZXPlainFlowLayout.h"
#import "YZXCalendarModel.h"
#import "YZXCalendarCollectionViewHeaderView.h"

#import "YZXCalendarHelper.h"
#import "YZXCalendarHeader.h"
#import "UIColor+Hexadecimal.h"

#import "Macro.h"
#define collectionView_width (iPhone5SE ? self.bounds.size.width - 1.5 : (iPhone6Plus_6sPlus ? self.bounds.size.width - 1 : self.bounds.size.width - 0.5))

#define dayView_width (collectionView_width / 7.f)

static const CGFloat dayView_Height = 40.0;
static const CGFloat collectionView_headerHeight = 20.0;

@interface YZXDaysMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//collectionView数据
@property (nonatomic, copy) NSArray <YZXCalendarModel *>                *collectionViewData;
//manager
@property (nonatomic, strong) YZXCalendarHelper                         *calendarHelper;
//数据
@property (nonatomic, strong) YZXCalendarModel                          *model;

@end

static NSString *collectionViewCellIdentify = @"calendarCell";
static NSString *collectionViewHeaderIdentify = @"calendarHeader";

@implementation YZXDaysMenuView {
    NSString *_startDateString;
    NSString *_endDateString;
}

- (instancetype)initWithFrame:(CGRect)frame withStartDateString:(NSString *)startDateString endDateString:(NSString *)endDateString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.hasOrderArray = [NSMutableArray array];
        
        self.lastHasOrderArray = [NSMutableArray array];

        [kNotificationCenter addObserver:self selector:@selector(operationHasOrderArray:) name:carlenderhasOrderArrayName object:nil];
        
        [kNotificationCenter addObserver:self selector:@selector(operationLastHasOrderArray:) name:lastCarlenderhasOrderArrayName object:nil];

//        NSArray *dates = [@"20190404,20190408" componentsSeparatedByString:@","];
//        for (int i = 0; i < dates.count; i ++) {
//            NSString *date = [HPTimeString noPortraitLineToDateStr:dates[i]];
//            if (![self.hasOrderArray containsObject:date]) {
//                [self.hasOrderArray addObject:date];
//            }
//        }
        
        _startDateString = startDateString;
        _endDateString = endDateString;
        [self p_initData];
        [self p_initView];
    }
    return self;
}

- (void)dealloc
{
    /*
     *移除指定通知
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:carlenderhasOrderArrayName object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:lastCarlenderhasOrderArrayName object:nil];

}

- (void)p_initData
{
    self.calendarHelper = YZXCalendarHelper.helper;
    
    self.model = [[YZXCalendarModel alloc] init];
    
    self.selectedArray = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[YZXCalendarHelper helper] yearMonthAndDayFormatter];
    NSDate *startDate = [formatter dateFromString:_startDateString];
    NSDate *endDate = [formatter dateFromString:_endDateString];
    
    self.collectionViewData = [self.model achieveCalendarModelWithData:startDate toDate:endDate];
}

- (void)p_initView
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZXCalendarCollectionViewHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIdentify];
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZXCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellIdentify];
    
    [self addSubview:self.collectionView];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.collectionViewData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewData[section].sectionRow * 7;
}

#pragma mark - 已经有其他商户预订
- (void)operationLastHasOrderArray:(NSNotification *)noti
{
    NSArray *dates = noti.userInfo[@"lastArray"];
    self.totalFee = noti.userInfo[@"totalFee"];

    if (dates.count == 1 && [dates.firstObject isEqualToString:@""]) {
        return;
    }
    for (int i = 0; i < dates.count; i ++) {
        NSString *date = [HPTimeString noPortraitLineToDateStr:dates[i]];
        if (![self.lastHasOrderArray containsObject:date]) {
            [self.lastHasOrderArray addObject:date];
        }
    }
    [self.collectionView reloadData];
}

- (void)operationHasOrderArray:(NSNotification *)noti
{
//    NSLog(@"ddddddd:%@",noti.userInfo[@"array"]);
    NSArray *dates = noti.userInfo[@"array"];
    for (int i = 0; i < dates.count; i ++) {
        NSString *date = [HPTimeString noPortraitLineToDateStr:dates[i]];
        if (![self.hasOrderArray containsObject:date] && ![date isEqualToString:@""]) {
            [self.hasOrderArray addObject:date];
        }
        [self.collectionView reloadData];
    }    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZXCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentify forIndexPath:indexPath];
    [cell layoutContentViewOfCollectionViewCellWithCellIndxePath:indexPath
                                                           model:self.collectionViewData[indexPath.section]];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%ld",self.totalFee.integerValue/30];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:cell.priceLabel.text];
    [attr addAttribute:NSFontAttributeName value:kFont_Regular(8.f) range:NSMakeRange(0, 1)];
    [attr addAttribute:NSFontAttributeName value:kFont_Regular(11.f) range:NSMakeRange(1, cell.priceLabel.text.length - 1)];
    cell.priceLabel.attributedText = attr;
    
    //默认情况下显示的状态
    if (cell.day.text.length) {
        cell.isHidden = NO;
        cell.priceLabel.hidden = NO;
    }
    if (cell.day.text.length == 0) {
        [cell changeDayBackgroundColor:[UIColor whiteColor]];
        cell.isHidden = YES;
        cell.priceLabel.hidden = YES;
    }

    //未选择情况
    if (_selectedArray.count == 0 && [YZXCalendarHelper.helper determineWhetherForTodayWithIndexPaht:indexPath model:self.collectionViewData[indexPath.section]] == YZXDateEqualToToday && !self.customSelect) {
        [_selectedArray addObject:indexPath];

    }
    //选择一个日期
    if (self.selectedArray.count == 1) {
        [cell changeDayBackgroundColor:COLOR_RED_EA0000];
        
    }else{
        cell.isHidden = NO;
        cell.priceLabel.hidden = NO;
        [cell changeDayBackgroundColor:COLOR_GRAY_FFFFFF];

    }
    
    if (self.selectedArray.count == 2 && [indexPath compare:self.selectedArray.firstObject] == NSOrderedDescending && [indexPath compare:self.selectedArray.lastObject] == NSOrderedAscending) {
        [cell changeDayBackgroundColor:COLOR_RED_EA0000];
        if (cell.day.text.length) {
            cell.isHidden = NO;
            cell.priceLabel.hidden = NO;
            cell.day.textColor = COLOR_GRAY_FFFFFF;
        }
        if (cell.day.text.length == 0) {
            [cell changeDayBackgroundColor:[UIColor whiteColor]];
            cell.isHidden = YES;
            cell.priceLabel.hidden = YES;
        }
    }else{
        cell.isHidden = NO;
        cell.priceLabel.hidden = NO;
        [cell changeDayBackgroundColor:COLOR_GRAY_FFFFFF];
        if (cell.day.text.length == 0) {
            [cell changeDayBackgroundColor:[UIColor whiteColor]];
            cell.isHidden = YES;
            cell.priceLabel.hidden = YES;
        }
    }
    
    //将选中的按钮改变样式
    [self.selectedArray enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.section == indexPath.section && obj.item == indexPath.item) {
            [cell changeDayBackgroundColor:COLOR_RED_EA0000];
            cell.isHidden = NO;
            cell.priceLabel.hidden = NO;
            [cell changeDayTextColor:[UIColor whiteColor]];
            cell.day.textColor = COLOR_GRAY_FFFFFF;
            if (cell.day.text.length) {
                cell.isHidden = NO;
                cell.priceLabel.hidden = NO;
            }
            if (cell.day.text.length == 0) {
                [cell changeDayBackgroundColor:[UIColor whiteColor]];
                cell.isHidden = YES;
                cell.priceLabel.hidden = YES;
            }
            
        }else{

        }
    }];

    //已经被其他用户预订的
    for (int i = 0 ;i < self.lastHasOrderArray.count;i++) {
        if ([[self.lastHasOrderArray[i] substringToIndex:8] isEqualToString:self.collectionViewData[indexPath.section].headerTitle]){
            NSInteger lasthasday = [[self.lastHasOrderArray[i] substringWithRange:NSMakeRange(8, 2)] integerValue];
            NSInteger day = indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2);

            if (lasthasday == day) {
                cell.priceLabel.text = @"已预订";
                cell.priceLabel.font = kFont_Medium(10.f);
                [cell changeDayBackgroundColor:COLOR_GRAY_EEEEEE];
                cell.priceLabel.textColor = COLOR_GRAY_999999;
                
            }else{
                cell.priceLabel.font = cell.originalFont;
            }
        }else{
            cell.priceLabel.text = cell.originalPrice;
            cell.priceLabel.textColor = cell.originalColor;

        }
    }
    
    //当前用户要预订的
    for (int i = 0 ;i < self.hasOrderArray.count;i++) {
        if ([self.collectionViewData[indexPath.section].headerTitle isEqualToString:[self.hasOrderArray[i] substringToIndex:8]]){
            NSInteger hasday = [[self.hasOrderArray[i] substringWithRange:NSMakeRange(8, 2)] integerValue];
            NSInteger day = indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2);
            if (hasday == day) {
                cell.priceLabel.font = kFont_Medium(10.f);
                [cell changeDayBackgroundColor:COLOR_RED_EA0000];
                cell.priceLabel.textColor = cell.originalColor;
                cell.day.textColor = COLOR_GRAY_FFFFFF;

            }else{
                cell.priceLabel.font = cell.originalFont;
            }
        }
        if (self.hasOrderArray.count > 0) {
            cell.userInteractionEnabled = NO;
        }else{
            cell.userInteractionEnabled = YES;

        }
    }
    
    //默认只显示近三个月的时间
    if (indexPath.section != self.collectionViewData.count -1 && indexPath.section != self.collectionViewData.count -2 && indexPath.section != self.collectionViewData.count -3) {
        [cell changeDayBackgroundColor:[UIColor whiteColor]];
        cell.isHidden = NO;
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //自定义选择
    if (self.customSelect) {
        switch (self.selectedArray.count) {
            case 0://选择第一个时间
            {
//                if ([cell.day.text isEqualToString:@"9"]) {
//                    [HPProgressHUD alertMessage:@"已预订，请重新选择"];
//                    return;
//                }
                //设置点击的cell的样式
                [self p_changeTheSelectedCellStyleWithIndexPath:indexPath];
                //记录当前点击的cell
                [self.selectedArray addObject:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
                [self.collectionView reloadData];

                if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarWithStartDate:andEndDate:)]) {
                    NSString *startString = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[indexPath.section].headerTitle,indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2)];
                    
                    [_delegate clickCalendarWithStartDate:startString andEndDate:nil];
                }
            }
                break;
            case 1://选择第二个时间
            {
                //如果第二次的选择和第一次的选择一样，则表示取消选择
                if (self.selectedArray.firstObject.section == indexPath.section && self.selectedArray.firstObject.item == indexPath.item) {
                    [self p_recoveryIsNotSelectedWithIndexPath:self.selectedArray.firstObject];
                    [self.selectedArray removeAllObjects];
                    if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarWithStartDate:andEndDate:)]) {
                        [_delegate clickCalendarWithStartDate:nil andEndDate:nil];
                    }
                    return;
                }
                
                NSString *startDate = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[self.selectedArray.firstObject.section].headerTitle,self.selectedArray.firstObject.item - (self.collectionViewData[self.selectedArray.firstObject.section].firstDayOfTheMonth - 2)];
                NSString *endDate = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[indexPath.section].headerTitle,indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2)];
            
                YZXCalendarHelper *helper = [YZXCalendarHelper helper];
                NSDateComponents *components = [helper.calendar components:NSCalendarUnitDay fromDate:[helper.yearMonthAndDayFormatter dateFromString:startDate] toDate:[helper.yearMonthAndDayFormatter dateFromString:endDate] options:0];
                //当设置了maxChooseNumber时判断选择的时间段是否超出范围
                if (self.maxChooseNumber) {
                    if (labs(components.day) > self.maxChooseNumber - 1) {

                        if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarWithStartDate:andEndDate:)]) {
                            [_delegate clickCalendarWithStartDate:startDate andEndDate:@"error"];
                        }
                        return;
                    }
                    
                }
                
                //记录当前点击的cell
                [self.selectedArray addObject:[NSIndexPath indexPathForRow:indexPath.item inSection:indexPath.section]];
                
                //对selectedArray进行排序，小的在前，大的在后
                [self p_sortingTheSelectedArray];
                //排序之后重新确定开始和结束时间
                startDate = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[self.selectedArray.firstObject.section].headerTitle,self.selectedArray.firstObject.item - (self.collectionViewData[self.selectedArray.firstObject.section].firstDayOfTheMonth - 2)];
                endDate = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[self.selectedArray.lastObject.section].headerTitle,self.selectedArray.lastObject.item - (self.collectionViewData[self.selectedArray.lastObject.section].firstDayOfTheMonth - 2)];
                //时间选择完毕，刷新界面
                [self.collectionView reloadData];
                
                //代理返回数据
                if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarWithStartDate:andEndDate:)]) {
                    [_delegate clickCalendarWithStartDate:startDate andEndDate:endDate];
                }
            }
                break;
            case 2://重新选择
            {
                //重新选择时，将之前点击的cell恢复成未点击状态，并移除数组中所有对象
                [self.selectedArray removeAllObjects];

                //记录当前点击的cell
                [self.selectedArray addObject:indexPath];
                
                [self.collectionView reloadData];
                //
                if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarWithStartDate:andEndDate:)]) {
                    NSString *startString = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[indexPath.section].headerTitle,indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2)];
                    
                    [_delegate clickCalendarWithStartDate:startString andEndDate:nil];
                }
            }
                break;
            default:
                break;
        }
    }else {//非自定义选择
        //移除已选中cell
        [self.selectedArray removeAllObjects];
        //记录当前点击的按钮
        [self.selectedArray addObject:indexPath];
        
        //设置点击的cell的样式
        [self p_changeTheSelectedCellStyleWithIndexPath:indexPath];
        
        if (_delegate && [_delegate respondsToSelector:@selector(clickCalendarDate:)]) {
            NSString *dateString = [NSString stringWithFormat:@"%@%02ld日",self.collectionViewData[indexPath.section].headerTitle,indexPath.item - (self.collectionViewData[indexPath.section].firstDayOfTheMonth - 2)];
            [_delegate clickCalendarDate:dateString];
        }
    }
}

//判断输入的是否是汉字，yes是输入汉字， No不是汉字
- (BOOL)judgeInputIsChinese:(NSString *)textStr{
    NSString *regex = @"[\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:textStr];
    return isMatch;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YZXCalendarCollectionViewHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewHeaderIdentify forIndexPath:indexPath];
        headerView.textLabel.text = self.collectionViewData[indexPath.section].headerTitle;
        HPLog(@"dddd:%@ indexPath.section:%ld self.collectionViewData.count:%ld",self.collectionViewData[indexPath.section].headerTitle,indexPath.section,self.collectionViewData.count);
        
        return headerView;
    }
    return [[UICollectionReusableView alloc] init];
}

//对选中的selectedArray中的数据排序
- (void)p_sortingTheSelectedArray
{
    if ([self.selectedArray.firstObject compare:self.selectedArray.lastObject] == NSOrderedDescending) {
        self.selectedArray = [[[[self.selectedArray copy] reverseObjectEnumerator] allObjects] mutableCopy];
    }
}

//改变cell的样式为选中
- (void)p_changeTheSelectedCellStyleWithIndexPath:(NSIndexPath *)indexPath
{
    YZXCalendarCollectionViewCell *cell = (YZXCalendarCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell changeDayBackgroundColor:CustomColor(@"EA0000")];
    [cell changeDayTextColor:[UIColor whiteColor]];
    
}

//恢复成为未选中状态
- (void)p_recoveryIsNotSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    //回复之前选择的cell样式
    YZXCalendarCollectionViewCell *selectedCell = (YZXCalendarCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell changeDayBackgroundColor:[UIColor whiteColor]];
    
    //判断之前点击的是否为周末和当天
    if ([self p_judgepWeekendAndToday:indexPath]) {
        [selectedCell changeDayTextColor:CustomColor(@"dd514d")];
    }else {
        [selectedCell changeDayTextColor:CustomColor(@"4a4a4a")];
    }
}

//判断是否为周末和当天
- (BOOL)p_judgepWeekendAndToday:(NSIndexPath *)indexPath
{
    BOOL todayFlag = ([YZXCalendarHelper.helper determineWhetherForTodayWithIndexPaht:indexPath model:self.collectionViewData[indexPath.section]] == YZXDateEqualToToday);
    return indexPath.item % 7 == 0 || indexPath.item % 7 == 6 || todayFlag;
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        YZXPlainFlowLayout *layout = [[YZXPlainFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(dayView_width, dayView_Height);
        layout.headerReferenceSize = CGSizeMake(collectionView_width, collectionView_headerHeight);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 6;
        layout.minimumInteritemSpacing = 0;
        layout.naviHeight = collectionView_headerHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((iPhone5SE ? 0.5 : 0), 0, collectionView_width, self.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:(self.collectionViewData.lastObject.numberOfDaysOfTheMonth + self.collectionViewData.lastObject.firstDayOfTheMonth - 2) inSection:self.collectionViewData.count - 1] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
    };
    return _collectionView;
}

#pragma mark - setter
- (void)setStartDate:(NSString *)startDate
{
    _startDate = startDate;
    if (!_startDate) {
        return;
    }
    //传入一个时间时，查找其indexPath信息，用在collectionView上展现
    [self.collectionViewData enumerateObjectsUsingBlock:^(YZXCalendarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.headerTitle isEqualToString:[self->_startDate substringWithRange:NSMakeRange(0, 8)]]) {
            NSInteger day = [self->_startDate substringWithRange:NSMakeRange(8, 2)].integerValue;
            [self.selectedArray addObject:[NSIndexPath indexPathForItem:(day + obj.firstDayOfTheMonth - 2) inSection:idx]];
            [self->_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:(self.collectionViewData[idx].sectionRow * 7 - 1) inSection:idx] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
            *stop = YES;
        }
    }];
    
    [_collectionView reloadData];
}

- (void)setDateArray:(NSArray *)dateArray
{
    _dateArray = dateArray;
    if (!_dateArray) {
        return;
    }
    //传入两个时间时，查找其indexPath信息，用在collectionView上展现
    [self.collectionViewData enumerateObjectsUsingBlock:^(YZXCalendarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.headerTitle isEqualToString:[self->_dateArray.firstObject substringWithRange:NSMakeRange(0, 8)]]) {
            NSInteger day = [self->_dateArray.firstObject substringWithRange:NSMakeRange(8, 2)].integerValue;
            [self.selectedArray addObject:[NSIndexPath indexPathForItem:(day + obj.firstDayOfTheMonth - 2) inSection:idx]];
        }
        if ([obj.headerTitle isEqualToString:[self->_dateArray.lastObject substringWithRange:NSMakeRange(0, 8)]]) {
            NSInteger day = [_dateArray.lastObject substringWithRange:NSMakeRange(8, 2)].integerValue;
            [self.selectedArray addObject:[NSIndexPath indexPathForItem:(day + obj.firstDayOfTheMonth - 2) inSection:idx]];
            [self->_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:(self.collectionViewData[idx].sectionRow * 7 - 1) inSection:idx] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
        }
    }];
    
    [_collectionView reloadData];
}

- (void)setCustomSelect:(BOOL)customSelect
{
    _customSelect = customSelect;
}

- (void)setMaxChooseNumber:(NSInteger)maxChooseNumber
{
    _maxChooseNumber = maxChooseNumber;
}

@end
