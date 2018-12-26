//
//  HPGamesCell.h
//  HPShareApp
//
//  Created by HP on 2018/12/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPBaseTableViewCell.h"
#import "HPBannerView.h"
#import "HPPageControl.h"
#import "HPPageControlFactory.h"
typedef void (^TapClickImageViewBlcok)(NSInteger tap);
typedef NS_ENUM(NSInteger, HPGamesCellIndex) {
    HPGamesCellIndexNinePointNine = 110,
    HPGamesCellIndexpfrofessionalGoods
};
NS_ASSUME_NONNULL_BEGIN

@interface HPGamesCell : HPBaseTableViewCell<HPBannerViewDelegate>

/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *fatherView;
@property (nonatomic, strong) HPBannerView *bannerView;

/**
 活动专区图片数组
 */
@property (nonatomic, strong) NSMutableArray *gamesImageArr;

@property (nonatomic, strong) UIButton *_Nonnull gamesLeftBtn;
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UIButton *_Nonnull gamesRightBtn;
@property (nonatomic, strong) UILabel *rightLabel;

/**
 点击活动选项事件s处理
 */
@property (nonatomic, copy) TapClickImageViewBlcok tapClickImageViewBlcok;
@end

NS_ASSUME_NONNULL_END
