//
//  HPReviseReleaseInfoViewController.m
//  HPShareApp
//
//  Created by HP on 2018/12/21.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPReviseReleaseInfoViewController.h"
#import "HPRightImageButton.h"
#import "HPTimeRentView.h"
#import "HPRowPanel.h"
#import "HPRentAmountItemView.h"
#import "CDZPicker.h"
#import "HPIntentionListModel.h"

typedef NS_ENUM(NSInteger, HPShareGotoBtnTag) {
    HPShareGotoBtnTagSpace = 30,
    HPShareGotoBtnTagTimeDuring,
    HPShareGotoBtnTagInsustry,
    HPShareGotoBtnTagRectType,
    HPShareGotoBtnTagRect,
    HPShareGotoBtnTagLeaves
};
@interface HPReviseReleaseInfoViewController ()

/**
 空间大小按钮
 */
@property (nonatomic, strong) HPRightImageButton *spaceBtn;
@property (nonatomic, strong) HPRightImageButton *shareTimeBtn;
@property (nonatomic, strong) HPRightImageButton *industryBtn;
/**
 出租模式按钮
 */
@property (nonatomic, strong) HPRightImageButton *rectTypeBtn;
/**
 租金按钮
 */
@property (nonatomic, strong) HPRightImageButton *rectBtn;
/**
 备注信息按钮
 */
@property (nonatomic, strong) HPRightImageButton *leavesBtn;
@property (strong, nonatomic) HPTimeRentView *timeRentView;
@property (strong, nonatomic) HPRentAmountItemView *amountItemView;

/**
 模式
 */
@property (nonatomic, strong) HPRowPanel *rentModelPanel;

/**
 金额
 */
@property (nonatomic, strong) HPRowPanel *rentAmountPanel;


/**
  租赁模式
 */
@property (nonatomic, strong) UIView *lastPanel;

@property (strong, nonatomic) NSMutableArray *modelArr;

/**
 当前选中的租赁价格
 */
@property (nonatomic, copy) NSString *currentPrice;
@property (nonatomic, strong) NSMutableArray *intentionArray;
@end

@implementation HPReviseReleaseInfoViewController
- (void)onClickBackBtn {
    HPLog(@"确定放弃此次完善信息操作？");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _intentionArray = [NSMutableArray array];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getIntentionIndustry];
}

#pragma mark - 获取意向行业类型
- (void)getIntentionIndustry
{
    [HPHTTPSever HPGETServerWithMethod:@"/v1/intentionIndustry/list" isNeedToken:YES paraments:@{} complete:^(id  _Nonnull responseObject) {
        if (CODE == 200) {
            self.intentionArray = [HPIntentionListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        }else{
            [HPProgressHUD alertMessage:MSG];
        }
    } Failure:^(NSError * _Nonnull error) {
        ErrorNet
    }];
}

- (void)setupUI {
    [self setupNavigationBarWithTitle:@"完善店铺共享信息"];
    for (int i = 0; i < 7; i++) {
        [self setupPanelAtIndex:i ofView:self.scrollView];
    }
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = COLOR_GRAY_FFFFFF;
    [self.view insertSubview:bottomView aboveSubview:self.scrollView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, getWidth(83.f) + g_bottomSafeAreaHeight));
    }];
    
    UIButton *releaseBtn = [[UIButton alloc] init];
    [releaseBtn.layer setCornerRadius:7.f];
    [releaseBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [releaseBtn setBackgroundColor:COLOR_RED_EA0000];
    [releaseBtn.titleLabel setFont:kFont_Bold(16.f)];
    [releaseBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(onClickReleaseBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:releaseBtn];
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(getWidth(45.f));
        make.left.top.mas_equalTo(getWidth(20.f));
        make.right.mas_equalTo(getWidth(-21.f));
    }];
}

- (void)onClickReleaseBtn {
    
}
#pragma mark - 信息完整度
- (UIView *)setUpInfoLabel
{
    UIView *view = [UIView new];
    UILabel *infoLabel = [UILabel new];
    infoLabel.backgroundColor = COLOR_BLUE_D5F2FF;
    infoLabel.text = [NSString stringWithFormat:@"信息完善度越高搜索排名越靠前，当前信息完善度为%@",@"30%"];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:infoLabel.text];
    NSString *str = @"信息完善度越高搜索排名越靠前，当前信息完善度为";
    NSRange range = [infoLabel.text rangeOfString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_BLACK_666666 range:range];
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:COLOR_RED_FF3C5E range:NSMakeRange(range.length, infoLabel.text.length - str.length)];
    [attr addAttribute:NSFontAttributeName value:kFont_Medium(12.f) range:NSMakeRange(range.length, infoLabel.text.length - str.length)];
    infoLabel.attributedText = attr;
    [view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return view;
}

#pragma mark - row view
- (void)setupPanelAtIndex:(NSInteger)index ofView:(UIView *)view {
    HPRowPanel *panel = [[HPRowPanel alloc] init];
    [view addSubview:panel];
    if (index == 0) {
        [panel addRowView:[self setUpInfoLabel] withHeight:25.f * g_rateWidth];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.scrollView);
            make.top.equalTo(view);
            make.height.mas_equalTo(getWidth(25.f));
            make.width.mas_equalTo(self.view);
        }];
        
    }
    else if (index == 1) {
        //店铺空间大小
        [panel addRowView:[self setupStoreSpaceRowView] withHeight:46.f * g_rateWidth];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(46.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
    }
    else if (index == 2) {
        [panel addRowView:[self setupShareTimeRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(46.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
    }
    else if (index == 3) {
        [panel addRowView:[self setupIndustryRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(46.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
    }else if (index == 4){
        //共享类型
        [panel addRowView:[self setupRentTypeRowView] withHeight:123.f * g_rateWidth];
        [panel addRowView:[self setUpTimeRentView] withHeight:getWidth(77.f)];
        UIView *lastPanel = view.subviews[index - 1];
        _lastPanel = lastPanel;
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(123.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        [panel shrinkFrom:1 to:1];
        _rentModelPanel = panel;
    }else if (index == 5) {
        //共享租金
        [panel addRowView:[self setupRentAmountRowView] withHeight:getWidth(137.f)];
        [panel addRowView:[self setupRentAmountItemRowView] withHeight:getWidth(91.f)];

        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(137.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        [panel shrinkFrom:1 to:1];
        _rentAmountPanel = panel;
    }else if (index == 6) {
        [panel addRowView:[self setupShareLeavesRowView]];
        UIView *lastPanel = view.subviews[index - 1];
        [panel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(view);
            make.height.mas_equalTo(46.f * g_rateWidth);
            make.top.equalTo(lastPanel.mas_bottom).with.offset(PANEL_SPACE);
        }];
        
    }
}

#pragma mark - 租金item
- (UIView *)setupRentAmountItemRowView
{
    UIView *view = [UIView new];
    HPRentAmountItemView *amountItemView = [HPRentAmountItemView new];
    UIView *expandView = [self addRowOfParentView:view withHeight:91.f * g_rateWidth margin:0.f isEnd:YES];
    expandView.backgroundColor = UIColor.clearColor;
    [expandView addSubview:amountItemView];
    kWeakSelf(weakSelf);
    [amountItemView setRentAmountItemClickBtnBlock:^(NSString *model) {
        weakSelf.currentPrice = model;
    }];
    _amountItemView = amountItemView;
    [amountItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(expandView);
    }];
    return expandView;
}

#pragma mark - 空间row view
- (UIView *)setupStoreSpaceRowView {
    UIView *view = [UIView new];
    UIView *spaceView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [spaceView setTag:HPShareGotoBtnTagSpace];
    [spaceView addGestureRecognizer:tap];
    [self setupTitleLabelWithText:@"我能出租的空间大小" ofView:spaceView];
    HPRightImageButton *spaceBtn = [self setupGotoBtnWithTitle:@"不限"];
    [spaceBtn setTag:HPShareGotoBtnTagSpace];
    [spaceView addSubview:spaceBtn];
    _spaceBtn = spaceBtn;
    [_spaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(spaceView);
        make.right.equalTo(spaceView).with.offset(-20.f * g_rateWidth);
    }];
    
    return spaceView;
}

#pragma mark - 时间row view
- (UIView *)setupShareTimeRowView
{
    UIView *view = [[UIView alloc] init];
    UIView *timeView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [timeView setTag:HPShareGotoBtnTagTimeDuring];
    [timeView addGestureRecognizer:tap];
    [self setupTitleLabelWithText:@"我想出租的时间段" ofView:timeView];
    HPRightImageButton *shareTimeBtn = [self setupGotoBtnWithTitle:@"不限"];
    [shareTimeBtn setTag:HPShareGotoBtnTagTimeDuring];
    [shareTimeBtn addTarget:self action:@selector(onClickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:shareTimeBtn];
    _shareTimeBtn = shareTimeBtn;
    [_shareTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.right.equalTo(timeView).with.offset(-20.f * g_rateWidth);
    }];
    
    return timeView;

}

#pragma mark - 行业row view
- (UIView *)setupIndustryRowView
{
    UIView *view = [[UIView alloc] init];
    UIView *industryView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [industryView setTag:HPShareGotoBtnTagInsustry];
    [industryView addGestureRecognizer:tap];
    [self setupTitleLabelWithText:@"我想合作的行业类型" ofView:industryView];
    HPRightImageButton *industryBtn = [self setupGotoBtnWithTitle:@"面议"];
    [industryBtn setTag:HPShareGotoBtnTagInsustry];
    [industryBtn addTarget:self action:@selector(onClickTradeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [industryView addSubview:industryBtn];
    _industryBtn = industryBtn;
    [_industryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(industryView);
        make.right.equalTo(industryView).with.offset(-20.f * g_rateWidth);
    }];
    
    return industryView;
}
#pragma mark - 出租模式view
- (UIView *)setUpTimeRentView
{
    UIView *view = [UIView new];
    HPTimeRentView *timeRentView = [HPTimeRentView new];
    UIView *expandView = [self addRowOfParentView:view withHeight:123.f * g_rateWidth margin:0.f isEnd:YES];
    expandView.backgroundColor = UIColor.clearColor;
    [expandView addSubview:timeRentView];
    kWeakSelf(weakSelf);
    self.modelArr = [NSMutableArray array];

    [timeRentView setRentTypeClickBtnBlock:^(NSString *model) {
        //当前选中的租赁模式
        [weakSelf.rectTypeBtn setText:model];
        if (![weakSelf.modelArr containsObject:model]) {
            [weakSelf.modelArr addObject:model];
        }else{
            [weakSelf.modelArr removeObject:model];
        }
        [kNotificationCenter postNotificationName:@"rectType" object:nil userInfo:@{@"rectType":weakSelf.modelArr}];
    }];
    _timeRentView = timeRentView;
    [timeRentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(expandView);
    }];
    return expandView;
}
#pragma mark - 出租模式row view
- (UIView *)setupRentTypeRowView
{
    UIView *view = [[UIView alloc] init];
    UIView *rentView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    [self setupTitleLabelWithText:@"我想出租的模式" ofView:rentView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [rentView setTag:HPShareGotoBtnTagRectType];
    [rentView addGestureRecognizer:tap];
    HPRightImageButton *rectTypeBtn = [self setupGotoBtnWithTitle:@""];
    [rentView addSubview:rectTypeBtn];
    _rectTypeBtn = rectTypeBtn;
    [_rectTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rentView);
        make.right.equalTo(rentView).with.offset(-20.f * g_rateWidth);
    }];
    return rentView;
}

#pragma mark - 租金模式row view
- (UIView *)setupRentAmountRowView
{
    UIView *view = [[UIView alloc] init];
    UIView *rentView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [rentView setTag:HPShareGotoBtnTagRect];
    [rentView addGestureRecognizer:tap];
    [self setupTitleLabelWithText:@"我期望的共享租金" ofView:rentView];
    HPRightImageButton *rectBtn = [self setupGotoBtnWithTitle:@""];
    [rentView addSubview:rectBtn];
    _rectBtn = rectBtn;
    [_rectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rentView);
        make.right.equalTo(rentView).with.offset(-20.f * g_rateWidth);
    }];
    
    return rentView;
}

#pragma mark - 备注信息row view
- (UIView *)setupShareLeavesRowView
{
    UIView *view = [[UIView alloc] init];
    UIView *leavesView = [self addRowOfParentView:view withHeight:46.f * g_rateWidth margin:0.f isEnd:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickShareGotoButton:)];
    [leavesView setTag:HPShareGotoBtnTagLeaves];
    [leavesView addGestureRecognizer:tap];
    [self setupTitleLabelWithText:@"备注信息" ofView:leavesView];

    HPRightImageButton *leavesBtn = [self setupGotoBtnWithTitle:@""];
    [leavesView addSubview:leavesBtn];
    _leavesBtn = leavesBtn;
    [_leavesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leavesView);
        make.right.equalTo(leavesView).with.offset(-20.f * g_rateWidth);
    }];
    return leavesView;
}

- (HPRightImageButton *)setupGotoBtnWithTitle:(NSString *)title {
    HPRightImageButton *btn = [[HPRightImageButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"shouye_gengduo"]];
    [btn setFont:[UIFont fontWithName:FONT_MEDIUM size:14.f]];
    [btn setText:title];
    [btn setSpace:10.f];
    [btn setColor:COLOR_GRAY_999999];
    [btn setSelectedColor:COLOR_BLACK_333333];
    
    return btn;
}

- (void)onClickShareGotoButton:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case HPShareGotoBtnTagSpace:
            HPLog(@"租赁空间大小");
            break;
        case HPShareGotoBtnTagRectType:
            HPLog(@"租赁模式");
            if (_rentModelPanel.isShrink) {
                [_rentModelPanel expand];
                
                if (!_rentAmountPanel.isShrink) {
                    [_rentAmountPanel shrinkFrom:1 to:1];
                }
            }
            else {
                [_rentModelPanel shrinkFrom:1 to:1];
            }
            break;
        case HPShareGotoBtnTagTimeDuring:
            HPLog(@"租赁时间段");
            
            break;
        case HPShareGotoBtnTagInsustry:
            HPLog(@"租赁行业类型");
            [self setUpIndustryTypePickerView];
            break;
        case HPShareGotoBtnTagRect:
            HPLog(@"租赁金额");
            if (_rentAmountPanel.isShrink) {
                [_rentAmountPanel expand];
                
                if (!_rentModelPanel.isShrink) {
                    [_rentModelPanel shrinkFrom:1 to:1];
                }
            }
            else {
                [_rentAmountPanel shrinkFrom:1 to:1];
            }
            break;
        case HPShareGotoBtnTagLeaves:
            HPLog(@"租赁留言");
            [self pushVCByClassName:@"HPStoreLeavesViewController"];
            break;
        default:
            break;
    }
}

#pragma mark - 行业类型pickerview
- (void)setUpIndustryTypePickerView
{
    CDZPicker *pickerView = [CDZPicker new];
    pickerView.tipTitle = @"选择意向行业";
    CDZPickerBuilder *builder = [CDZPickerBuilder new];
    builder.showMask = YES;
    builder.cancelTextColor = COLOR_GRAY_BBBBBB;
    builder.confirmTextColor = COLOR_RED_EA0000;
    NSMutableArray *intentionArray = [NSMutableArray array];;
    for (int i = 0; i < self.intentionArray.count; i++) {
        HPIntentionListModel *model = self.intentionArray[i];
        [intentionArray addObject:model.industryName];
    }
    [CDZPicker showSinglePickerInView:self.view withBuilder:builder strings:intentionArray confirm:^(NSArray<NSString *> * _Nonnull strings, NSArray<NSNumber *> * _Nonnull indexs) {
        [self.industryBtn setText:[strings componentsJoinedByString:@","]];
        CGFloat stringsW = BoundWithSize([strings componentsJoinedByString:@","], kScreenWidth, 14).size.width + 20;
        [self.industryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(stringsW);
        }];
//        NSLog(@"strings:%@ indexs:%@",strings,indexs);
    }cancel:^{
        //your code
    }];
}

- (UIView *)addRowOfParentView:(UIView *)view withHeight:(CGFloat)height margin:(CGFloat)margin isEnd:(BOOL)isEnd {
    UIView *row = [[UIView alloc] init];
    [view addSubview:row];

    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        if (view.subviews.count == 1) {
            make.centerY.equalTo(view);
        }
        else {
            UIView *lastRow = view.subviews[view.subviews.count - 2];
            make.top.equalTo(lastRow.mas_bottom);
        }
        
        if (isEnd) {
            make.bottom.equalTo(view).with.offset(-margin);
        }
        
        make.right.equalTo(view).offset(getWidth(-20.f));
        make.height.mas_equalTo(height);
    }];
    
    return row;
}
@end
